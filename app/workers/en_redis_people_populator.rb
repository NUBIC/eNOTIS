require 'webservices/eirb'

class ENRedisPeoplePopulator
  @queue = :redis_people_populator
  Resque.before_first_fork do
    Eirb.connect
  end
  def self.perform(irb_number, use_case, force=false)
    r = Redis.new
    start_time = Time.now
    case use_case
    when "coordinator"
      coordinators_key = "eNOTIS:coordinators:#{irb_number}"
      unless r.exists(coordinators_key) || force==true
        Eirb.find_coordinators({:irb_number => irb_number}).each do |coordinator|
          netid = coordinator[:netid]
          r.lpush(coordinators_key,netid) unless r.lrange(coordinators_key,0,-1).include? netid
          Resque.enqueue(ENRedisLdapper,netid)
        end
      end
      end_time = Time.now
      puts "Imported #{coordinators_key} in #{end_time - start_time} seconds"
    when "co_investigators"
      co_investigators_key = "eNOTIS:co_investigators:#{irb_number}"
      unless r.exists(co_investigators_key) || force==true
        Eirb.find_co_investigators({:irb_number => irb_number}).each do |co_investigator|
          netid = co_investigator[:netid]
          r.lpush(co_investigators_key,netid) unless r.lrange(co_investigators_key,0,-1).include? netid
          Resque.enqueue(ENRedisLdapper,netid)
        end
      end
      end_time = Time.now
      puts "Imported #{co_investigators_key} in #{end_time - start_time} seconds"
    when "primary_investigators"
      pi_key = "eNOTIS:primary_investigators:#{irb_number}"
      unless r.exists(pi_key) || force == true
        Eirb.find_principal_investigators({:irb_number => irb_number}).each do |principal_investigator|
          netid = principal_investigator[:netid]
          r.lpush(pi_key,netid) unless r.lrange(pi_key,0,-1).include? netid
          Resque.enqueue(ENRedisLdapper,netid)
        end
      end
      end_time = Time.now
      puts "Imported #{pi_key} in #{end_time - start_time} seconds"
    end
  end
end
