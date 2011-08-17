require 'compass'
# If you have any compass plugins, require them here.
rails_root = (defined?(Rails) ? Rails.root : RAILS_ROOT).to_s
Compass.add_project_configuration(File.join(rails_root,"config","compass.rb"))
Compass.configuration.environment = RAILS_ENV.to_sym
Compass.configure_sass_plugin!
Compass.handle_configuration_change!
