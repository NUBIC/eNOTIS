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

require 'ruby-debug' if defined? Debugger # don't choke if we haven't the gem

config.after_initialize do
  Bcsec.configure do
    enotis = Bcsec::Authorities::Enotis.new
    authorities :cas, enotis
    central '/etc/nubic/bcsec-local.yml'
  end
end
require 'empi' # include the symbolize! Hash extension
EMPI_SERVICE =
  begin
    YAML::load(File.read("/etc/nubic/empi-#{Rails.env}.yml")).symbolize!
  rescue => e
    $stderr.puts "Warning: could not load EMPI_SERVICE configuration:\n  #{e}"
  end
