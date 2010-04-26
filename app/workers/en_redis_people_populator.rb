require 'webservices/eirb'

class ENRedisPeoplePopulator
  @queue = :redis_people_populator
  Resque.before_first_fork do
    Eirb.connect
  end
  
  def self.perform(irb_number, use_case, force=false)
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    redis = Redis::Namespace.new('eNOTIS', :redis => Redis.new(config))
    start_time = Time.now
    case use_case
    when "co_investigators"
      co_investigators_key = "co_investigators:#{irb_number}"
      if force==true
        import_co_investigators(irb_number,redis,co_investigators_key)
      else
        import_co_investigators(irb_number,redis,co_investigators_key) unless redis.exists(co_investigators_key)
      end
      end_time = Time.now
      puts "Imported #{co_investigators_key} in #{end_time - start_time} seconds"
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
  
  
  def self.import_co_investigators(irb_number,redis,co_investigators_key)
    Eirb.find_co_investigators({:irb_number => irb_number}).each do |co_investigator|
      netid,email = co_investigator[:netid],co_investigator[:email]
      redis.sadd(co_investigators_key,netid)
      Resque.enqueue(ENRedisLdapper,netid,email)
    end
  end
  
  def self.import_principal_investigators(irb_number,redis,pi_key)
    Eirb.find_principal_investigators({:irb_number => irb_number}).each do |principal_investigator|
      netid,email = principal_investigator[:netid],principal_investigator[:email]
      redis.sadd(pi_key,netid)
      Resque.enqueue(ENRedisLdapper,netid,email)
    end
  end
end
