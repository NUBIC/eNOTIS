require 'webservices/edw'
require 'will_paginate/array'
# require 'ruby_debug'
namespace :edw do
  namespace :subjects do
    namespace :redis do
      
      desc "Import EDW Subjects and involvements into Redis"
      task :import => :environment do
        if Rails.env.production?
          DEIDENTIFY=false
        else
          DEIDENTIFY=true
        end
        puts "#{Time.now}: Starting edw:subjects:redis:import"
        Edw.connect
        res      = Edw.find_subject_import_from_NOTIS
        PER_PAGE = 100
        REGEX    = /^STU.*/
        date     = Time.new.strftime("%Y:%m:%d-%I:%M:%p")
        date_key = "import:subject_extras:daily:#{date}"
        1.upto(res.paginate(:per_page=>PER_PAGE).total_pages) do |page|
          subject_array = res.paginate(:page => page, :per_page => PER_PAGE).select{|study| study[:irb_number] =~ REGEX}
          unless subject_array.blank?
            subject_array.each do |subject|
              subject_hash = HashWithIndifferentAccess.new(subject)
              begin
                irb_number  = subject_hash.delete(:irb_number).try(:strip)
                patient_id  = subject_hash.delete(:patient_id).try(:strip)
                subject_key = "subject:#{irb_number}:#{patient_id}:0"
                if REDIS.exists(subject_key)
                  unless HashWithIndifferentAccess.new(REDIS.hgetall(subject_key)).diff(subject_hash).blank?
                    old_subject_key = subject_key
                    nextincr        = subject_key.split(":")[3].to_i + 1
                    subject_key     = "subject:#{irb_number}:#{patient_id}:#{nextincr}"
                    REDIS.sadd(date_key, subject_key)
                  end
                end
                if DEIDENTIFY==true
                  subject_hash[:first_name] = patient_id
                  subject_hash[:last_name]  = patient_id
                  if !subject_hash[:birth_date].blank?
                    subject_hash[:birth_date] = date_randomizer(subject_hash[:birth_date])
                  end
                  subject_hash[:address_1] = "123 Main Street"
                  if !subject_hash[:death_date].blank?
                    subject_hash[:death_date] = date_randomizer(subject_hash[:death_date])
                  end
                end
                subject_hash.each do |k,v|
                  REDIS.hset(subject_key,k,v)
                end
              rescue Exception => e
                puts "Exception Caught: #{e.to_s}"
              end
            end
          end
        end
        puts "#{Time.now}: Finishing edw:subjects:redis:import"
      end

      def date_randomizer(date)
        Chronic.parse(date).instance_eval("self #{offset_randomizer}").to_formatted_s(:db)
      end

      def offset_randomizer
        "".tap do |str|
          str << " #{%w(+ -).rand} #{rand(30)}.days"
          str << " #{%w(+ -).rand} #{rand(11)}.months"
          str << " #{%w(+ -).rand} #{rand(10)}.years"
        end
      end

      desc "Destroy Notis Subjects"
      task :destroy => :environment do
        InvolvementEvent.paper_trail_off
        Involvement.paper_trail_off
        Subject.paper_trail_off
        Subject.on_notis_studies.find_each do |subject|
          subject.involvements.each do |inv|
            inv.involvement_events.destroy_all
            inv.destroy
          end
          subject.destroy
        end
        Subject.find_each(:conditions => {:data_source => "NOTIS"}) do |subject|
          subject.destroy
        end
        Subject.paper_trail_on
        Involvement.paper_trail_on
        InvolvementEvent.paper_trail_on
      end

      desc "Nuke"
      task :nuke => :environment do
        puts "#{Time.now}: Starting edw:subjects:redis:nuke"
        keys   = REDIS.keys 'subject:*'
        keys.each do |subject|
          REDIS.del subject
        end
        puts "#{Time.now}: Finishing edw:subjects:redis:nuke"
      end

      desc "Resque Import"
      task :enqueue => :environment do
        puts "#{Time.now}: Starting edw:subjects:redis:enqueue"
        keys   = REDIS.keys "subject:*:*:*"
        keys.each do |subject|
          Resque.enqueue(SubjectInvolvementPopulator,subject)
        end
        puts "#{Time.now}: Finishing edw:subjects:redis:enqueue"
      end

    end

  end
end
