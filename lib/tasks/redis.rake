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
    puts "Roles..."
    Role.update_from_redis
    puts "  Roles"
  end
  namespace :roles do
    desc "clear"
    task :clear=>:environment do
      redis = Redis.new
      keys =  redis.keys 'eNOTIS:role:*'
      keys.each{|k| redis.del k}
    end
  end

  namespace :resque do
    desc "Deliver Failure count of the day"
    task :failure_notify do
      if Resque::Failure.count >= 100
        Notifier.deliver_daily_failed_jobs
      end
    end
    
    desc "requeue failed jobs"
    task :requeue=> :environment do
      0.upto(Resque::Failure.count).each_with_index do |failure, index|
        begin
          Resque::Failure.requeue(index)
        rescue Exception => e
          puts "Failure at #{index}"
        ensure
        end
      end
      Resque::Failure.clear
    end
  end
  
end