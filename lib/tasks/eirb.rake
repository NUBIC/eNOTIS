namespace :eirb do
  desc "Sanity test for eIRB connection - Checks against test server"
  task :sanity_test do
   puts `ruby script/eirbtest.rb`
  end

  desc "Runs study import from data cache"
  task :study_import do
    `script/runner 'Study.update_from_cache'` 
  end

end

