class ENRedisBogusNetidPopulator

  @queue = :redis_bogus_netid

  def self.perform(netid, email, force=false)
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
    
    #TODO: Handle Bogus emails once Rhett adds the capability to BCSEC
  end
end