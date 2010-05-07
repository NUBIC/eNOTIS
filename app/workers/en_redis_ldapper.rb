class ENRedisLdapper
  @queue = :redis_ldapper
  
  def self.perform(netid, email, irb_number, force=false)
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
    
    r = Redis::Namespace.new('eNOTIS:role', :redis => Redis.new(config))
    user_key = "eNOTIS:user:#{netid}"
    unless r.exists(user_key) || force==true
      user = Bcsec::NetidAuthenticator.find_user(netid)
      if user 
        user.instance_values.each do |k,v|
          r.hset(user_key,k,v)
        end
      else
        Resque.enqueue(ENRedisBogusNetidPopulator, netid, email, irb_number)
      end
    end
    puts "Imported #{user_key}"
  end
end