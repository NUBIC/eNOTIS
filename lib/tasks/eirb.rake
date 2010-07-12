require 'webservices/eirb'

namespace :eirb do
  desc "Sanity test for eIRB connection - Checks against test server"
  task :sanity_test do
    puts `ruby script/eirbtest.rb`
  end

  namespace :redis_import do
    desc "Full Import"
    task :full => :environment do
      Eirb.connect
      date     = Time.new.strftime("%Y:%m:%d-%I:%M:%p")
      date_key = "import:study:full:#{date}"
      keys     = REDIS.keys '*'
      keys.each{|k| REDIS.del k}
      irb_numbers = Eirb.find_study_export
      irb_numbers.each do |numbers|
        irb_number = numbers[:irb_number]
        REDIS.sadd(date_key, irb_number)
        Resque.enqueue(StudyPopulator, irb_number, true)
        Resque.enqueue(AuthorizedPersonnelPopulator, irb_number)
      end
    end
    
    desc "Nightly 1 day import"
    task :nightly => :environment do
      Eirb.connect
      puts "#{Time.now}: Starting eirb:redis:import_nightly"
      puts "#{Time.now}: Starting eirb:redis:import_nightly - nightly updated studies"
      irb_numbers = Eirb.find_recent_studies
      date        = Time.new.strftime("%Y:%m:%d-%I:%M:%p")
      date_key    = "import:study:daily:#{date}"
      irb_numbers.each do |numbers|
        irb_number = numbers[:irb_number]
        REDIS.sadd(date_key, irb_number)
        Resque.enqueue(StudyPopulator, irb_number, true)
      end
      puts "#{Time.now}: Finishing eirb:redis:import_nightly - nightly updated studies"
      %w(role missing_person ).each do |cat|
        keys = REDIS.keys "#{cat}:*"
        keys.each{|k| REDIS.del k}
      end
      
      REDIS.del 'phantom_studies'
      REDIS.del 'missing:study'
      
      puts "#{Time.now}: Starting eirb:redis:import_nightly - all personnel fetch"
      irb_numbers = Eirb.find_study_export
      irb_numbers.each do |numbers|
        irb_number = numbers[:irb_number]
        Resque.enqueue(AuthorizedPersonnelPopulator, irb_number)
      end
      puts "#{Time.now}: Finishing eirb:redis:import_nightly - all personnel fetch"
      puts "#{Time.now}: Finishing eirb:redis:import_nightly"
    end
  end
end