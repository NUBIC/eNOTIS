class Ldapper
  @queue = :redis_ldapper
  
  def self.perform(irb_number, netid, project_role, consent_role, source, redo_netid=nil)
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

    user_key = "user:#{netid}"
    unless REDIS.exists(user_key) || redo_netid
      user = Bcsec::NetidAuthenticator.find_user(netid)
      if user
        user.instance_variables.each do |var|
          REDIS.hset(user_key,var.gsub("@",""),user.instance_variable_get(var))
        end
      else
        Resque.enqueue(BogusNetidProcessor, netid, irb_number, project_role, consent_role ,source)
      end
    end
    if source == "authorized_personnel"
      userhash = HashWithIndifferentAccess.new(REDIS.hgetall(user_key))
      create_role_entry(REDIS, irb_number, netid, project_role, consent_role, userhash[:email])
    end
  end

  def self.create_role_entry(redis, irb_number, netid, project_role, consent_role, email)
    authorized_person_key = "role:authorized_personnel:#{irb_number}:#{netid}"
    redis.hset(authorized_person_key, 'project_role', project_role)
    redis.hset(authorized_person_key, 'consent_role', consent_role)
    redis.hset(authorized_person_key, 'email', email)
  end

end