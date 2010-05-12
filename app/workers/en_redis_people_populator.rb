require 'webservices/eirb'

class ENRedisPeoplePopulator
  @queue = :redis_people_populator
  Resque.before_perform_jobs_per_fork do
    Eirb.connect
  end
  
  def self.perform(irb_number, use_case, force=false)
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    redis = Redis::Namespace.new('eNOTIS', :redis => Redis.new(config))
    start_time = Time.now
    case use_case
    when "coordinator"
      coordinators_key = "coordinators:#{irb_number}"
      if force==true
        import_coordinators(irb_number,redis,coordinators_key)
      else
        import_coordinators(irb_number,redis,coordinators_key) unless redis.exists(coordinators_key)
      end
      end_time = Time.now
      puts "Imported #{coordinators_key} in #{end_time - start_time} seconds"
    when "principal_investigators"
      pi_key = "principal_investigators:#{irb_number}"
      if force==true
        import_principal_investigators(irb_number,redis,pi_key)
      else
        import_principal_investigators(irb_number,redis,pi_key) unless redis.exists(pi_key)
      end
      end_time = Time.now
      puts "Imported #{pi_key} in #{end_time - start_time} seconds"
    end
  end
  def self.import_coordinators(irb_number,redis,coordinators_key)
    Eirb.find_coordinators({:irb_number => irb_number}).each do |coordinator|
      netid = coordinator[:netid]
      redis.sadd(coordinators_key,netid)
      Resque.enqueue(ENRedisLdapper,netid)
    end
  end
  
  def self.import_principal_investigators(irb_number,redis,pi_key)
    Eirb.find_principal_investigators({:irb_number => irb_number}).each do |principal_investigator|
      netid = principal_investigator[:netid]
      redis.sadd(pi_key,netid)
      Resque.enqueue(ENRedisLdapper,netid)
    end
  end
end
