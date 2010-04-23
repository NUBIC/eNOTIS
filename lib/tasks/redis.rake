# lib/tasks/redis.rake
desc 'Connects, updates studies, updates coordinators'
task :redis => :"redis:default"

namespace :redis do
  task :default => [:"redis:users", :"redis:studies", :'redis:roles']
  desc "Updates Users from Redis Cache"
  task :users => :environment do
    puts "Users..."
    User.update_from_redis
    puts "  Users Complete"
  end
  desc 'Updates studies from Redis Cache'
  task :studies => :environment do
    puts "Studies..."
    Study.update_from_redis
    puts "  Studies complete"
  end
  
  desc 'Updates roles'
  task :roles => :environment do
    puts "Authorized Personnel..."
    Role.update_from_redis
    puts "  Authorized Personnel"
  end
end