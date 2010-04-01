class ENRedisLdapper
  @queue = :redis_ldapper
  
  def self.perform(netid, force=false)
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
    
    r = Redis.new
    user_key = "eNOTIS:user:#{netid}"
    unless r.exists(user_key) || force==true
      Bcsec::NetidAuthenticator.find_user(netid).instance_values.each do |k,v|
        r.hset(user_key,k,v)
      end
    end
    puts "Imported #{user_key}"
  end
end