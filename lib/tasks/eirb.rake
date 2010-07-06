namespace :eirb do
  desc "Sanity test for eIRB connection - Checks against test server"
  task :sanity_test do
    puts `ruby script/eirbtest.rb`
  end

  namespace :redis_import do
    desc "Full Import"
    task :full => :environment do
      require 'webservices/eirb'
      Eirb.connect
      config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
      redis  = Redis::Namespace.new('eNOTIS', :redis => Redis.new(config))
      keys   = redis.keys '*'
      keys.each{|k| redis.del k}
      puts "#{Time.now}: Getting status for all studies "
      irb_numbers = Eirb.find_study_export
      puts "#{Time.now}: finishing getting status "
      irb_numbers.each do |numbers|
        irb_number = numbers[:irb_number]
        puts "Priming queues for #{irb_number}"
        Resque.enqueue(StudyPopulator, irb_number, true)
        Resque.enqueue(AuthorizedPersonnelPopulator, irb_number)
      end
    end
    
    desc "Nightly 1 day import"
    task :nightly => :environment do
      require 'webservices/eirb'
      Eirb.connect
      puts "#{Time.now}: getting status "
      irb_numbers = Eirb.find_recent_studies
      puts "#{Time.now}: finishing getting status "
      irb_numbers.each do |numbers|
        irb_number = numbers[:irb_number]
        puts "Priming queues for #{irb_number}"
        Resque.enqueue(StudyPopulator, irb_number, true)
      end
      config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
      redis  = Redis::Namespace.new('eNOTIS', :redis => Redis.new(config))
      %w(role missing_person).each do |cat|
        keys = redis.keys "#{cat}:*"
        keys.each{|k| redis.del k}
      end
      puts "#{Time.now}: Getting All Study IRB Numbers "
      irb_numbers = Eirb.find_study_export
      puts "#{Time.now}: Finished "
      irb_numbers.each do |numbers|
        irb_number = numbers[:irb_number]
        Resque.enqueue(AuthorizedPersonnelPopulator, irb_number)
      end
    end
  end
end