# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# development environment gems
config.gem "rspec-rails", :version => '>=1.2.7.1', :lib => 'spec/rails'
config.gem "rspec", :version => '>=1.2.8', :lib => 'spec'

config.gem "webrat", :version => '>=0.4.4', :lib => false
config.gem "cucumber", :version => '>=0.3.11', :lib => false # also installs dependencies: term-ansicolor, polyglot, treetop, diff-lcs, builder
config.gem "rcov", :version => '>=0.8.1.2.0'
config.gem "ZenTest", :version => '>=4.1.1'

config.gem "ruby-debug-base", :version => '>=0.10.3' # also installs dependencies: linecache
config.gem "ruby-debug", :version => '>=0.10.3' # also installs dependencies: columnize

config.gem "thoughtbot-factory_girl", :version => '>=1.2.1', :lib => "factory_girl", :source => "http://gems.github.com"
config.gem "populator", :version => '>=0.2.5'
config.gem "faker", :version => '>=0.3.1'
  

require 'ruby-debug' if defined? Debugger # don't choke if we haven't the gem, e.g. the first time we run rake gems:install

