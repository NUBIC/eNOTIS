require 'webservices/edw'
require 'will_paginate/array'
require 'ruby_debug'
namespace :edw do
  namespace :redis do
    desc "Import EDW Data into Redis"
    task :notis_import => :environment do
      Edw.connect
      puts "Starting to pull info from EDW"
      res      = Edw.find_subject_import_from_NOTIS
      puts "Finished pulling results from EDW"
      PER_PAGE = 100
      REGEX    = /^STU.*/
      config   = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
      redis    = Redis::Namespace.new('eNOTIS:subject', :redis => Redis.new(config))
      1.upto(res.paginate(:per_page=>PER_PAGE).total_pages) do |page|
        puts "\nPage #{page}\n"
        subject_array = res.paginate(:page => page, :per_page => PER_PAGE).select{|study| study[:irb_number] =~ REGEX}
        unless subject_array.blank?
          subject_array.each do |subject|
            begin
              irb_number  = subject.delete(:irb_number).try(:strip)
              patient_id  = subject.delete(:patient_id).try(:strip)
              subject_key = "#{irb_number}:#{patient_id}:0"
              if redis.exists(subject_key)
                puts "we have more than one subject for study on #{subject_key}"
                nextincr    = subject_key.split(":")[2].to_i + 1
                subject_key = "#{irb_number}:#{patient_id}:#{nextincr}"
              end
              puts "Importing subject for key #{subject_key}"
              subject.each do |k,v|
                redis.hset(subject_key,k,v)
              end
            rescue Exception => e
              puts "Exception Caught: #{e.to_s}"
            end
          end        
        end
      end
    end
    
    desc "Resque Import"
    task :enqueue => :environment do
      config   = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
      redis    = Redis::Namespace.new('eNOTIS:subject', :redis => Redis.new(config))
      subject_keys = redis.keys "*:*:0"
      subject_keys.each do |subject|
        Resque.enqueue(EnRedisNotisImport,subject)
        # irb_number  = subject.delete(:irb_number).try(:strip)
        # patient_id  = subject.delete(:patient_id).try(:strip)
        # subject_key = "#{irb_number}:#{patient_id}:0"
      end
    end
    desc "Nuke"
    task :nuke => :environment do
      config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
      redis  = Redis::Namespace.new('eNOTIS:subject', :redis => Redis.new(config))
      keys   = redis.keys '*'
      keys.each do |key|
        redis.del key
      end
    end
  end
end