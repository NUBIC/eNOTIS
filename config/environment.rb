# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install

  # all environments gems
  # For lib/gem loading errors, see http://www.webficient.com/2008/07/11/ruby-on-rails-gem-dependencies-and-plugin-errors
  
  config.gem "haml", :version => '>=2.2.0', :lib => false # required by chriseppstein-compass
  config.gem "chriseppstein-compass", :version => '>=0.8.13', :lib => false
  config.gem "soap4r", :version => '>=1.5.8', :lib => false # :lib => false fixes no such file to load
  config.gem "libxml-ruby", :version => '>=1.1.3', :lib => false # :lib => false fixes no such file to load
  config.gem "fastercsv", :version => '>=1.5.0'
  config.gem "paperclip", :version => '>=2.1.2'
  config.gem "bcdatabase", :version => '<1.0.0'
  config.gem "bcsec" #, :source => "http://download.bioinformatics.northwestern.edu/gems/"
  config.gem "airblade-paper_trail", :lib => 'paper_trail', :version => '>=1.1.1'
  config.gem "chronic", :version => '>=0.2.3'
  config.gem "stomp", :version => '>=1.1'
  config.gem "binarylogic-searchlogic", :lib => 'searchlogic'
  config.gem "yoon-view_trail", :lib => 'view_trail', :version => '>=0.3.1', :source => 'http://gems.github.com'
  config.gem "capistrano", :version => '>=2.5.8'
  config.gem "activemessaging"
  config.gem "ruport", :lib => false
  config.gem "acts_as_reportable", :lib => false
  config.gem "aasm"

  config.gem "thoughtbot-factory_girl", :version => '>=1.2.1', :lib => "factory_girl", :source => "http://gems.github.com"
  config.gem "populator", :version => '>=0.2.5'
  config.gem "faker", :version => '>=0.3.1'
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  # Email setup
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
   :address => "ns.northwestern.edu",
   :port => 25,
   :domain => "northwestern.edu"
  }

end
