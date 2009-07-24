# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "cucumber"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'

# Comment out the next line if you don't want Cucumber Unicode support
require 'cucumber/formatter/unicode'

# Comment out the next line if you don't want transactions to
# open/roll back around each scenario
Cucumber::Rails.use_transactional_fixtures

# Comment out the next line if you want Rails' own error handling
# (e.g. rescue_action_in_public / rescue_responses / rescue_from)
Cucumber::Rails.bypass_rescue

require 'webrat'

Webrat.configure do |config|
  config.mode = :rails
end

require 'cucumber/rails/rspec'
require 'webrat/core/matchers'

# for stubbing
require "spec/mocks"

Before do
  $rspec_mocks ||= Spec::Mocks::Space.new
end

After do
  begin
    $rspec_mocks.verify_all
  ensure
    $rspec_mocks.reset_all
  end
end

# # for mocking EDWAdapter
# require 'spec/adapters/mock_frameworks/rspec'
# include Spec::Adapters::MockFramework
# 
# Before do
#    setup_mocks_for_rspec
# end
# 
# After do
#    begin
#      verify_mocks_for_rspec
#    ensure
#      teardown_mocks_for_rspec
#    end
# end
