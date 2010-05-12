require 'webservices/eirb'
class ENRedisBogusNetidPopulator
  @queue = :redis_bogus_netid
  Resque.before_perform_jobs_per_fork do
    Eirb.connect
  end

  def self.perform(netid, irb_number, project_role, consent_role)
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    r = Redis::Namespace.new('eNOTIS', :redis => Redis.new(config))
    user_key = "user:#{netid}"
    missing_person_key = "unknown_users:#{netid}"
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

    user = HashWithIndifferentAccess.new(Eirb.find_user({:netid=>netid})[0])

    if user 
      puts "Found #{netid}"
      found_by_email = Bcsec::NetidAuthenticator.find_user(:email=>user[:email])
      found_by_name = begin
        Bcsec::NetidAuthenticator.find_user(:first_name=>user[:first_name], :last_name=>user[:last_name])
      rescue Exception => e
        nil
      end
      if found_by_email
        puts "We've found #{netid} in BCSEC by email"
        unless r.exists("user#{found_by_email.username}")
          found_by_email.instance_values.each do |k,v|
            r.hset(user_key,k,v)
          end
        end
        r.hset("user_aliases", netid, found_by_email.username)
        create_role_entry(r, irb_number, found_by_email.username, project_role, consent_role, found_by_email.email)
      elsif found_by_name
        puts "We've found #{netid} in BCSEC by name"
        unless r.exists("user#{found_by_name.username}")
          found_by_name.instance_values.each do |k,v|
            r.hset(user_key,k,v)
          end
        end
        r.hset("user_aliases", netid, found_by_name.username)
        create_role_entry(r, irb_number, found_by_name.username, project_role, consent_role, found_by_name.email)
      else
        puts "Needs further digging on #{netid}"
        unless r.exists("unknown_users:#{netid}")
          user.instance_values.each do |k,v|
            r.hset("unknown_users:#{netid}",k,v)
          end
        end
        missing_authorized_personnel_key = "role:invalid_netid:authorized_personnel:#{irb_number}:#{netid}"
        r.hset(missing_authorized_personnel_key, 'project_role', project_role)
        r.hset(missing_authorized_personnel_key, 'consent_role', consent_role)
        r.hset(missing_authorized_personnel_key, 'email', user[:email])
        r.hset(missing_authorized_personnel_key, 'first_name', user[:first_name])
        r.hset(missing_authorized_personnel_key, 'last_name', user[:last_name])
      end
    else
      puts "Missing #{netid}"
    end
  end

  def self.create_role_entry(redis, irb_number, netid, project_role, consent_role, email)
    authorized_person_key = "role:authorized_personnel:#{irb_number}:#{netid}"
    redis.hset(authorized_person_key, 'project_role', project_role)
    redis.hset(authorized_person_key, 'consent_role', consent_role)
    redis.hset(authorized_person_key, 'email', email)
  end

end