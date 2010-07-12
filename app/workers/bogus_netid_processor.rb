require 'webservices/eirb'
class BogusNetidProcessor
  @queue = :redis_bogus_netid
  Resque.before_perform_jobs_per_fork do
    Eirb.connect
  end

  def self.perform(netid, irb_number, project_role, consent_role, source)

    # Setup LDAP
    if Rails.env.production?
      conf_data = YAML::load(File.read("/etc/nubic/bcsec-prod.yml"))
    else
      conf_data = YAML::load(File.read("/etc/nubic/bcsec-staging.yml"))
    end
    
    # Configure BCSEC
    Bcsec.configure do
      authenticators  :netid
      ldap_user       conf_data["netid"]["user"]
      ldap_password   conf_data["netid"]["password"]
      ldap_server     "directory.northwestern.edu"
    end

    # Setup Redis

    # First, access the User information from the Review Board
    # If the user is not in the review board, then dump it in another resque queue
    eirb_user = HashWithIndifferentAccess.new(Eirb.find_user({:netid=>netid})[0])

    if !eirb_user.blank?
      email = eirb_user[:email]
      # Now we look up the user in LDAP by email address and first and last name
      found_by_email = Bcsec::NetidAuthenticator.find_user(:email=>email)
      
      # Sometimes this crashes.. 
      # TODO: investigate this later
      found_by_name = begin
        Bcsec::NetidAuthenticator.find_user(:first_name=>eirb_user[:first_name], :last_name=>eirb_user[:last_name])
      rescue Exception => e
        nil
      end
      
      if found_by_email
        email_lookup(found_by_email, REDIS, irb_number, netid, project_role, consent_role, email, source)
      elsif found_by_name
        name_lookup(found_by_name, REDIS, irb_number, netid, project_role, consent_role, email, source)
      else
        not_in_ldap(eirb_user, source, REDIS, irb_number, project_role, consent_role)
      end
    else
      Resque.enqueue(MissingNetidProcessor, netid, irb_number, project_role, consent_role ,source)
    end
  end
  
  def self.email_lookup(bcsec_result, redis, irb_number, netid, project_role, consent_role, email, source)
    new_netid = bcsec_result.username
    new_email = bcsec_result.email
    puts "We've found #{netid} in BCSEC by email #{new_email} as #{new_netid}"
    bcsec_result.instance_variables.each do |var|
      redis.hset("user:#{new_netid}",var.gsub("@",""),bcsec_result.instance_variable_get(var))
    end
    redis.hset("role:user_aliases", netid, new_netid)
    change_netid(source, redis, irb_number, netid, new_netid, project_role, consent_role, new_email)
  end
  
  def self.name_lookup(bcsec_result, redis, irb_number, netid, project_role, consent_role, email, source)
    new_netid = bcsec_result.username
    new_name  = "#{bcsec_result.first_name} #{bcsec_result.last_name}"
    new_email = bcsec_result.email
    puts "We've found #{netid} in BCSEC by name #{new_name} as #{new_netid}"
    bcsec_result.instance_variables.each do |var|
      redis.hset("user:#{new_netid}",var.gsub("@",""), bcsec_result.instance_variable_get(var))
    end
    redis.hset("role:user_aliases", netid, new_netid)
    change_netid(source, redis, irb_number, netid, new_netid, project_role, consent_role, new_email)
  end
  
  def self.change_netid(source, redis, irb_number, old_netid, new_netid, project_role, consent_role, new_email)
    case source
    when "pi"
      key = "role:principal_investigators:#{irb_number}"
    when "coi"
      key = "role:co_investigators:#{irb_number}"
    when "authorized_personnel"
      key = "role:authorized_people:#{irb_number}"
      old_ap_key = "role:authorized_personnel:#{irb_number}:#{old_netid}"
      new_ap_key = "role:authorized_personnel:#{irb_number}:#{new_netid}"
      redis.rename(old_ap_key, new_ap_key)
      redis.hset(new_ap_key, 'email', new_email)
    end
    redis.srem(key,old_netid)
    redis.sadd(key,new_netid)
    Resque.enqueue(Ldapper, irb_number, new_netid, project_role, consent_role, source, true)
  end
    
  def self.not_in_ldap(eirb_user, source, redis, irb_number, project_role, consent_role )
    netid = eirb_user[:username]
    puts "#{netid} not in NU LDAP for #{irb_number} - #{project_role} - #{consent_role} - #{eirb_user[:email]}"
    eirb_user.each do |k,v|
      redis.hset("missing_person:#{netid}",k,v)
    end
    missing_user_key = "role:missing_person:#{irb_number}:#{netid}"
    redis.hset(missing_user_key, 'project_role', project_role)
    redis.hset(missing_user_key, 'consent_role', consent_role)
    redis.hset(missing_user_key, 'email', eirb_user[:email])
    case source
    when "pi"
      redis.srem("role:principal_investigators:#{irb_number}",netid)
    when "coi"
      redis.srem("role:co_investigators:#{irb_number}",netid)
    when "authorized_personnel"
      redis.srem("role:authorized_people:#{irb_number}",netid)
      redis.del("role:authorized_personnel:#{irb_number}:#{netid}")
    end
  end

end