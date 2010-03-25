namespace :eirb do
  desc "Sanity test for eIRB connection - Checks against test server"
  task :sanity_test do
   puts `ruby script/eirbtest.rb`
  end

  desc "Runs study import from data cache"
  task :study_import do
    `script/runner 'Study.update_from_cache'` 
  end
  
  desc "nightly_validation"
  task :nightly_validation=>:environment do
    require 'webservices/eirb'
    Eirb.connect
    Eirb.find_status.each do |result|
      Resque.enqueue ENStudyWorker, result[:irb_number]
    end
  end
end

