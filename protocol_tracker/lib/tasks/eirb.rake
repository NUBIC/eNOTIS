namespace :eirb do
  desc "Sanity test for eIRB connection - Checks against test server"
  task :sanitiy_test do
   puts `ruby script/eirbtest.rb`
  end

end
