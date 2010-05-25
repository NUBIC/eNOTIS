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
  
  desc "Construct Missing Person Report"
  task :missing_person_report => :environment  do
    config     = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    redis      = Redis::Namespace.new('eNOTIS', :redis => Redis.new(config))
    keys = redis.keys 'role:missing_person:*'
    FasterCSV.open("tmp/report.csv", "w") do |csv|
      csv << ["IRB Number", "Netid", "First Name", "Last Name", "Email Address", "Title", "Project Role", "Consent Role"]
      keys.each do |key|
        study,netid    = key.split(':')[2],key.split(':')[3]
        missing_study  = HashWithIndifferentAccess.new(redis.hgetall key)
        missing_person = HashWithIndifferentAccess.new(redis.hgetall "missing_person:#{netid}")
        csv << [study, netid, missing_person[:first_name], missing_person[:last_name], missing_person[:email], missing_person[:title], missing_study[:project_role], missing_study[:consent_role]]
      end
    end
  end
  
  desc "Fix Aliases"
  task :fix_aliases => :environment do
    config     = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    redis      = Redis::Namespace.new('eNOTIS', :redis => Redis.new(config))
    aliases = redis.hgetall('role:user_aliases')
    aliases.each do |old_netid,new_netid|
      user = User.find(:first, :conditions=>{:netid=>new_netid})
      irb_numbers = user.roles.map{|role| role.study}.map{|study| study.irb_number}
      puts "Old Netid: #{old_netid} - NETID = #{user.netid} : on studies #{irb_numbers.join(", ")}"
    end
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