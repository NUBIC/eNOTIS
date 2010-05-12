class ENRedisBogusNetidPopulator
  @queue = :redis_bogus_netid
  Resque.before_perform_jobs_per_fork do
    Eirb.connect
  end
  
  def self.perform(netid)
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
      puts "\nFound #{netid}"
      found_by_email = Bcsec::NetidAuthenticator.find_user(:email=>user[:email])
      found_by_name = begin
        Bcsec::NetidAuthenticator.find_user(:first_name=>user[:first_name], :last_name=>user[:last_name])
      rescue Exception => e
        nil
      end
      if found_by_email
        puts "We've found #{netid} in BCSEC by email"
        found_by_email.instance_values.each do |k,v|
          r.hset(user_key,k,v)
        end
        r.hset("user_aliases", netid, found_by_email.username)
      elsif found_by_name
        puts "We've found #{netid} in BCSEC by name"
        found_by_name.instance_values.each do |k,v|
          r.hset(user_key,k,v)
        end
        r.hset("user_aliases", netid, found_by_name.username)
      else
        puts "Needs further digging on #{netid}"
        user.instance_values.each do |k,v|
          r.hset("unknown_users:#{netid}",k,v)
        end
      end
    else
      puts "\nMissing #{netid}"
    end    
  end
end