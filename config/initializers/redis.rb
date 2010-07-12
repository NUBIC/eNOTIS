require 'yaml'
config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
REDIS  = Redis::Namespace.new('eNOTIS', :redis => Redis.new(config))
