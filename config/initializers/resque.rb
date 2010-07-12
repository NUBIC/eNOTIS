require 'yaml'
rails_root    = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env     = ENV['RAILS_ENV'] || 'development'
resque_config = YAML.load_file(rails_root + '/config/resque.yml')
Resque.redis  = resque_config[rails_env]
Resque.redis.namespace = "resque:eNOTIS"
require 'resque_scheduler'
Resque.schedule = YAML.load_file(File.join(File.dirname(__FILE__), '../resque_schedule.yml'))

