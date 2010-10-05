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
    # The authorities to use.  See the bcsec API documentation
    # for `Bcsec::Authorities` for options.
    enotis = Enotis::Bcsec::Authority.new
    static = Bcsec::Authorities::Static.from_file(File.expand_path("../../static_auth.yml", __FILE__))
    authorities static, enotis

    # The server-central parameters file for cc_pers, NU LDAP,
    # CAS, and policy parameters.
    central 'config/static_auth.yml'
  end
end
require 'empi' # include the symbolize! Hash extension
EMPI_SERVICE = YAML::load(File.read("/etc/nubic/empi-#{Rails.env}.yml")).symbolize!