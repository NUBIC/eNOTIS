class ENCoordinatorChecker
  @queue = :person_validator
  
  # Create the study from information fetched from the EIRB
  def self.perform(irb_number, study_id)
    puts "I'f this were written, i'd be getting information about user #{netid}"
    # use TTL Caching to and a duplication redis set to ensure that i'm not pulling multiple people from the list
    
    study = Study.find(study_id)
    if study.coordinators
    else
    end
    # study.coordinators.map(&:user).each do |study_user|
    #   begin
    #     # This could be resque-ized
    #     ldap_user = Bcsec::NetidAuthenticator.find_user(study_user.netid)
    #     study_user.address_line1 = ldap_user.address.split("\n")[0]
    #     study_user.address_line2 = ldap_user.address.split("\n")[1]
    #     study_user.address_line2 = ldap_user.address.split("\n")[2]
    #     study_user.city          = ldap_user.city
    #     #country is missing
    #     study_user.email         = ldap_user.email
    #     study_user.first_name    = ldap_user.first_name
    #     study_user.last_name     = ldap_user.last_name
    #     study_user.middle_name   = ldap_user.middle_name
    #     study_user.phone_number  = ldap_user.business_phone
    #     study_user.title         = ldap_user.title
    #     study_user.save
    #   rescue Exception => e
    #   ensure
    #   end
    # end
  
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
