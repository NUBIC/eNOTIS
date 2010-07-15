if RAILS_ENV=="hudson"

gem 'ci_reporter' 
require 'ci/reporter/rake/rspec'
require 'ci/reporter/rake/test_unit'

namespace :ci do
  task :setup_rspec => "ci:setup:rspec"
  task :setup_testunit => "ci:setup:testunit"
end

end
