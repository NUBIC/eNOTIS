# lib/tasks/redis.rake
desc 'Connects, updates studies, updates coordinators'
task :redis => :"redis:default"

namespace :redis do
  task :default => [:"redis:users", :"redis:studies", :"redis:principal_investigators", :"redis:co_investigators", :coordinators]


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
  
  desc 'Updates Principal Investigators'
  task :principal_investigators => :environment do
    puts "Principal Investigators..."
    Study.update_from_redis
    puts "  Principal Investigators complete"
  end

  desc 'Updates CoInvestigators'
  task :co_investigators => :environment do
    puts "Co_Investigators..."
    Study.update_from_redis
    puts "  Co_Investigators complete"
  end

  desc 'Updates coordinators'
  task :coordinators => :environment do
    puts "Coordinators..."
    Study.update_from_redis
    puts "  Coordinators complete"
  end
  desc 'Updates authorized_personnel'
  task :authorized_personnel => :environment do
    puts "Authorized Personnel..."
    AuthorizedPerson.update_from_redis
    puts "  Authorized Personnel"
  end
  
end