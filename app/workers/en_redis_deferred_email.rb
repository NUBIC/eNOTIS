class ENRedisDeferredEmail
  @queue = :redis_deferred_email
  
  def self.perform(irb_number, netid, project_role, consent_role)
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
    r = Redis::Namespace.new('eNOTIS:role', :redis => Redis.new(config))
    user_key = "eNOTIS:user:#{netid}"
    if r.exists(user_key)
      userhash = HashWithIndifferentAccess.new(r.hgetall(user_key))
      create_role_entry(r, irb_number, netid, project_role, consent_role, userhash[:email])
    else
      user = Bcsec::NetidAuthenticator.find_user(netid)
      if user
        user.instance_values.each do |k,v|
          r.hset(user_key,k,v)
        end
      end
      userhash = HashWithIndifferentAccess.new(r.hgetall(user_key))
      create_role_entry(r, irb_number, netid, project_role, consent_role, userhash[:email])
    end
    puts "Imported #{user_key}"
  end
  
  def self.create_role_entry(redis, irb_number, netid, project_role, consent_role, email)
    authorized_person_key = "authorized_personnel:#{irb_number}:#{netid}"
    redis.hset(authorized_person_key, 'project_role', project_role)
    redis.hset(authorized_person_key, 'consent_role', consent_role)
    redis.hset(authorized_person_key, 'email', email)
  end
end