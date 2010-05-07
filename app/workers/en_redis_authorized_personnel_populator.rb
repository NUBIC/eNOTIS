require 'webservices/eirb'

class ENRedisAuthorizedPersonnelPopulator
  @queue = :redis_authorized_personnel_populator
  Resque.before_perform_jobs_per_fork do
    Eirb.connect
  end
  
  def self.perform(irb_number, force=false)
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    redis = Redis::Namespace.new('eNOTIS:role', :redis => Redis.new(config))
    start_time = Time.now
    principal_investigators = Eirb.find_principal_investigators({:irb_number => irb_number})
    principal_investigators.each do |principal_investigator|
      netid = principal_investigator[:netid]
      pi_key = "principal_investigators:#{irb_number}"
      redis.sadd(pi_key,netid)
      Resque.enqueue(ENRedisDeferredEmail, irb_number, netid, 'Principal Investigator', 'Obtaining')
    end
    co_investigators =  Eirb.find_co_investigators({:irb_number => irb_number})
    co_investigators.each do |coi|
      netid = coi[:netid]
      co_investigator_key = "co_investigators:#{irb_number}"
      redis.sadd(co_investigator_key,netid)
      Resque.enqueue(ENRedisDeferredEmail, irb_number, netid, 'Co-Investigator', 'Obtaining')
    end
    priveleged_netids =  principal_investigators.map{|x| x[:netid]}.compact + co_investigators.map{|x| x[:netid]}.compact
    authorized_people = Eirb.find_authorized_personnel({:irb_number => irb_number})
    authorized_people.reject!{|person| priveleged_netids.include? person[:netid]}
    authorized_people.each do |authorized_person|  
      Resque.enqueue(ENRedisLdapper, authorized_person[:netid], authorized_person[:email], irb_number, force)
      authorized_person_key = "authorized_personnel:#{authorized_person[:irb_number]}:#{authorized_person[:netid]}"
      redis.hset(authorized_person_key, 'project_role', authorized_person[:project_role])
      redis.hset(authorized_person_key, 'consent_role', authorized_person[:consent_role])
      redis.hset(authorized_person_key, 'email', authorized_person[:email])
    end
    end_time = Time.now
    puts "#{end_time}: Imported Roles for study # #{irb_number} in #{end_time - start_time} seconds"
  end
end
