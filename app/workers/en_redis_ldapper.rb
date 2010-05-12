class ENRedisLdapper
  @queue = :redis_ldapper
  
  Resque.before_perform_jobs_per_fork do
    if Rails.env.production?
      conf_data = YAML::load(File.read("/etc/nubic/bcsec-prod.yml"))
    else
      # puts "if you havent already start the ssh tunnel: sudo ssh -f -N -L 636:directory.northwestern.edu:636 <<YourNetID>>@enotis-staging.nubic.northwestern.edu" unless Rails.env.staging?
      conf_data = YAML::load(File.read("/etc/nubic/bcsec-staging.yml"))
    end
    Bcsec.configure do
      authenticators  :netid
      ldap_user       conf_data["netid"]["user"]
      ldap_password   conf_data["netid"]["password"]
      ldap_server     "directory.northwestern.edu"
    end
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    REDIS = Redis::Namespace.new('eNOTIS', :redis => Redis.new(config))
  end
  
  def self.perform(irb_number, netid, project_role, consent_role)
    user_key = "user:#{netid}"
    if REDIS.exists(user_key)
      userhash = HashWithIndifferentAccess.new(REDIS.hgetall(user_key))
      create_role_entry(REDIS, irb_number, netid, project_role, consent_role, userhash[:email])
    else
      user = Bcsec::NetidAuthenticator.find_user(netid)
      if user
        user.instance_values.each do |k,v|
          REDIS.hset(user_key,k,v)
        end
      else
        Resque.enqueue(ENRedisBogusNetidPopulator, netid )
      end
      userhash = HashWithIndifferentAccess.new(REDIS.hgetall(user_key))
      create_role_entry(REDIS, irb_number, netid, project_role, consent_role, userhash[:email])
    end
    puts "Imported #{user_key}"
  end
  
  def self.create_role_entry(redis, irb_number, netid, project_role, consent_role, email)
    authorized_person_key = "role:authorized_personnel:#{irb_number}:#{netid}"
    redis.hset(authorized_person_key, 'project_role', project_role)
    redis.hset(authorized_person_key, 'consent_role', consent_role)
    redis.hset(authorized_person_key, 'email', email)
  end
  
  # def self.perform(net_id, irb_number, force=false)
  #   netid = net_id.downcase
  #   if Rails.env.production?
  #     conf_data = YAML::load(File.read("/etc/nubic/bcsec-prod.yml"))
  #   else
  #     # puts "if you havent already start the ssh tunnel: sudo ssh -f -N -L 636:directory.northwestern.edu:636 <<YourNetID>>@enotis-staging.nubic.northwestern.edu" unless Rails.env.staging?
  #     conf_data = YAML::load(File.read("/etc/nubic/bcsec-staging.yml"))
  #   end
  #   Bcsec.configure do
  #     authenticators  :netid
  #     ldap_user       conf_data["netid"]["user"]
  #     ldap_password   conf_data["netid"]["password"]
  #     ldap_server     "directory.northwestern.edu"
  #   end
  #   config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
  #   r = Redis::Namespace.new('eNOTIS', :redis => Redis.new(config))
  #   user_key = "user:#{netid}"
  #   unless r.exists(user_key) || force==true
  #     user = Bcsec::NetidAuthenticator.find_user(netid)
  #     if user 
  #       user.instance_values.each do |k,v|
  #         r.hset(user_key,k,v)
  #       end
  #     else
  #       if netid == ''
  #         r.sadd "missing_person_study:_BLANK_", irb_number
  #       else
  #         r.sadd "missing_person_study:#{netid}", irb_number
  #       end
  #       Resque.enqueue( ENRedisBogusNetidPopulator, netid )
  #     end
  #   end
  #   puts "Imported #{user_key}"
  # end
end