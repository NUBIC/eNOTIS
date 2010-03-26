class ENLdapLookup
  @queue = :ldap_lookup
  
  # Create the study from information fetched from the EIRB
  def self.perform(netid)
    puts "I'f this were written, i'd be getting information about user #{netid}"
    # use TTL Caching to and a duplication redis set to ensure that i'm not pulling multiple people from the list
    
    # if Rails.env.production?
    #   conf_data = YAML::load(File.read("/etc/nubic/bcsec-prod.yml"))
    # else
    #   conf_data = YAML::load(File.read("/etc/nubic/bcsec-staging.yml"))
    # end
    # Bcsec.configure do
    #   authenticators  :netid
    #   ldap_user       conf_data["netid"]["user"]
    #   ldap_password   conf_data["netid"]["password"]
    #   ldap_server     "directory.northwestern.edu"
    # end
    
    # Eirb.connect
    # Eirb.find_basics({:irb_number=>irb_number})
  end
end
