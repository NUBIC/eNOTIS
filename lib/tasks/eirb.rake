namespace :eirb do
  desc "Sanity test for eIRB connection - Checks against test server"
  task :sanity_test do
    puts `ruby script/eirbtest.rb`
  end

  desc "Runs study import from data cache"
  task :study_import do
    `script/runner 'Study.update_from_cache'` 
  end

  namespace :redis_import do
    desc "Full Import"
    task :full => :environment do
      require 'webservices/eirb'
      Eirb.connect
      puts "#{Time.now}: Getting status for all studies "
      irb_numbers = Eirb.find_study_export
      puts "#{Time.now}: finishing getting status "
      irb_numbers.each do |numbers|
        irb_number = numbers[:irb_number]
        puts "Priming queues for #{irb_number}"
        # Resque.enqueue(ENRedisStudyPopulator, irb_number)
        Resque.enqueue(ENRedisAuthorizedPersonnelPopulator, irb_number)
        # Resque.enqueue(ENRedisPeoplePopulator, irb_number, 'coordinator')
        # Resque.enqueue(ENRedisPeoplePopulator, irb_number, 'co_investigators')
        # Resque.enqueue(ENRedisPeoplePopulator, irb_number, 'principal_investigators')
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
        Resque.enqueue(ENRedisStudyPopulator, irb_number, true)
        Resque.enqueue(ENRedisPeoplePopulator, irb_number, 'coordinator', true)
        Resque.enqueue(ENRedisPeoplePopulator, irb_number, 'co_investigators', true)
        Resque.enqueue(ENRedisPeoplePopulator, irb_number, 'principal_investigators', true)
      end
    end
  end
end