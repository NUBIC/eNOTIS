require 'webservices/eirb'

class ENRedisAuthorizedPersonnelPopulator
  @queue = :redis_authorized_personnel_populator
  Resque.before_first_fork do
    Eirb.connect
  end
  
  def self.perform(irb_number, force=false)
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    redis = Redis::Namespace.new('eNOTIS:role', :redis => Redis.new(config))
    eirb_array = Eirb.find_authorized_personnel({:irb_number => irb_number})
    eirb_array.each do |authorized_person|
      Resque.enqueue(ENRedisLdapper,authorized_person[:netid],authorized_person[:email],irb_number, force)
      coordinator_key = "#{authorized_person[:irb_number]}:#{authorized_person[:netid]}"
      redis.hset(coordinator_key, 'project_role', authorized_person[:project_role])
      redis.hset(coordinator_key, 'consent_role', authorized_person[:consent_role])
      redis.hset(coordinator_key, 'email', authorized_person[:email])
      
    end
  end
end
