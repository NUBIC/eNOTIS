# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test


config.after_initialize do
  Bcsec.configure do
    # The authorities to use.  See the bcsec API documentation
    # for `Bcsec::Authorities` for options.
    enotis = Bcsec::Authorities::Enotis.new
    static = Bcsec::Authorities::Static.from_file(File.expand_path("../../static_auth.yml", __FILE__))
    authorities static, enotis

    # The server-central parameters file for cc_pers, NU LDAP,
    # CAS, and policy parameters.
    central 'config/static_auth.yml'
  end
end

# Use SQL instead of Active Record's schema dumper when creating the test database.
# This is necessary if your schema can't be completely dumped by the schema dumper,
# like if you have constraints or database-specific column types
# config.active_record.schema_format = :sql
require 'empi' # include the symbolize! Hash extension
EMPI_SERVICE = {:uri => nil, :credentials => nil}
config.middleware.delete('ResqueWeb')
