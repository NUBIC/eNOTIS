desc 'Connects, updates studies, updates coordinators'
task :redis => :"redis:default"

namespace :redis do
  task :default => [:"redis:users", :"redis:studies", :'redis:roles']
  desc "Updates Users from Redis Cache"
  task :users => :environment do
    puts "#{Time.now}: Users..."
    User.update_from_redis
    puts "#{Time.now}: Users complete"
  end
  desc 'Updates studies from redis'
  task :studies => :environment do
    puts "#{Time.now}: Studies..."
    Study.update_from_redis
    puts "#{Time.now}: Studies complete"
  end
  
  desc 'Updates roles from redis'
  task :roles => :environment do
    puts "#{Time.now}: Roles..."
    Role.update_from_redis
    puts "#{Time.now}: Roles complete"
  end
  
  desc "Construct Missing Person Report"
  task :missing_person_report => :environment  do
    keys = REDIS.keys 'role:missing_person:*'
    FasterCSV.open("tmp/report.csv", "w") do |csv|
      csv << ["IRB Number", "Netid", "First Name", "Last Name", "Email Address", "Title", "Project Role", "Consent Role"]
      keys.each do |key|
        study,netid    = key.split(':')[2],key.split(':')[3]
        missing_study  = HashWithIndifferentAccess.new(REDIS.hgetall key)
        missing_person = HashWithIndifferentAccess.new(REDIS.hgetall "missing_person:#{netid}")
        csv << [study, netid, missing_person[:first_name], missing_person[:last_name], missing_person[:email], missing_person[:title], missing_study[:project_role], missing_study[:consent_role]]
      end
    end
  end
  
  desc "Fix Aliases"
  task :fix_aliases => :environment do
    aliases = REDIS.hgetall('role:user_aliases')
    aliases.each do |old_netid,new_netid|
      user = User.find(:first, :conditions=>{:netid=>new_netid})
      irb_numbers = user.roles.map{|role| role.study}.map{|study| study.irb_number}
      puts "Old Netid: #{old_netid} - NETID = #{user.netid} : on studies #{irb_numbers.join(", ")}"
    end
  end
  
  namespace :roles do
    desc "clear"
    task :clear=>:environment do
      keys  = REDIS.keys 'role:*'
      keys.each{|k| REDIS.del k}
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