namespace :eirb do
  desc "Sanity test for eIRB connection - Checks against test server"
  task :sanity_test do
    puts `ruby script/eirbtest.rb`
  end

  desc "Runs study import from data cache"
  task :study_import do
    `script/runner 'Study.update_from_cache'` 
  end

  # TODO: get the most recent changes instead of pulling _everything_ every night
  desc "Nightly Queue primer for fresh data"
  task :redis_import=>:environment do
    require 'webservices/eirb'
    Eirb.connect
    puts "#{Time.now}: getting status "
    statuses = Eirb.find_status
    puts "#{Time.now}: finishing getting status "
    statuses.each do |result|
      irb_number = result[:irb_number]
      puts "Priming queues for #{irb_number}"
      Resque.enqueue(ENRedisStudyPopulator, irb_number)
      Resque.enqueue(ENRedisPeoplePopulator, irb_number, 'coordinator')
      Resque.enqueue(ENRedisPeoplePopulator, irb_number, 'co_investigators')
      Resque.enqueue(ENRedisPeoplePopulator, irb_number, 'primary_investigators')
    end
  end
end