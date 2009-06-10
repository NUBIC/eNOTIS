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
# config.gem "ruby-debug-base", :version => '0.10.3' # also installs dependencies: linecache
# config.gem "ruby-debug", :version => '0.10.3' # also installs dependencies: columnize

require 'ruby-debug' if defined? Debugger # don't choke if we haven't the gem, e.g. the first time we run rake gems:install

