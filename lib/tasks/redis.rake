# lib/tasks/redis.rake
desc 'Connects, updates studies, updates coordinators'
task :redis => :"redis:default"

namespace :redis do
  task :default => [:"redis:users", :"redis:studies", :"redis:coordinators"]
  
  desc "Updates Users"
  task :users => :environment do
    puts "Users..."
    User.redis_import
    puts "  Users Complete"
  end
  
  desc 'Updates studies'
  task :studies => :environment do
    puts "Studies..."
    Study.update_all_from_redis
    puts "  Studies complete"
  end

  desc 'Updates coordinators'
  task :coordinators => :environment do
    puts "Coordinators..."
    Study.update_coordinators_from_redis
    puts "  Coordinators complete"
  end
  
end

