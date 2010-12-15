module UsersToPers
  PORTAL = "eNOTIS" # should match Bcsec.configuration.portal in config/initializers/bcsec.rb
  
  # Creates the eNOTIS portal as well as Admin and User groups in cc_pers
  def self.setup
    unless enotis = Pers::Portal.find_by_name(PORTAL)
      enotis = Pers::Portal.new
      enotis.portal = PORTAL
      enotis.save
    end
    %w(Admin User).each do |gn|
      enotis.groups.create(:group_name => gn) unless enotis.groups.find_by_group_name(gn)
    end
  end
  # Creates eNOTIS developers and admins in cc_pers
  def self.create_admins
    %w(blc615 Brian Chamberlain daw286 David Were lmw351 Laura Wimbiscus\ Yoon myo628 Mark Wimbiscus\ Yoon wakibbe Warren Kibbe).each_slice(3) do |netid, first_name, last_name|
      Pers::Person.create(:username => netid, :first_name => first_name, :last_name => last_name) unless Pers::Person.find_by_username(netid)
      unless Pers::Login.find_by_username_and_portal(netid, PORTAL)
        login = Pers::Login.new
        login.username = netid
        login.portal_name = PORTAL # can't be bulk set
        login.save
      end
      Pers::GroupMembership.create(:username => netid, :group_name => "Admin", :portal => PORTAL) unless Pers::GroupMembership.find_by_username_and_portal_and_group_name(netid, PORTAL, "Admin")
      Pers::GroupMembership.create(:username => netid, :group_name => "User", :portal => PORTAL) unless Pers::GroupMembership.find_by_username_and_portal_and_group_name(netid, PORTAL, "User")
    end
  end
  
  # Fills in cc_pers from the redis copy of the ldap server
  # TODO: untested!
  def self.update_from_redis
    users = REDIS.keys 'user:*'
    users.each do |redis_user|
      netid = redis_user.split(":")[1].downcase
      user_hash = HashWithIndifferentAccess.new(REDIS.hgetall(redis_user))
      unless Pers::Person.find_by_username_or_id(netid)
        u = Pers::Person.new(
              :username => user_hash[:username], 
              :first_name => user_hash[:first_name],
              :last_name => user_hash[:last_name],
              :middle_name => user_hash[:middle_name],
              :title => user_hash[:title],
              :email => user_hash[:email],
              :business_phone => user_hash[:phone_number],
              :address1 => user_hash[:address].split("\n")[1],
              :address2 => user_hash[:address].split("\n")[2],
              :city => user_hash[:city],
              :state => user_hash[:state],
              :postal_code => user_hash[:zip],
              :country => user_hash[:country])
        unless u.save
          puts "cant save #{user_hash[:username]}"
        end
      end
      # u = self.find_by_netid(netid) || self.new
      # u.email       = user_hash[:email]
      # u.first_name  = user_hash[:first_name]
      # u.last_name   = user_hash[:last_name]
      # u.middle_name = user_hash[:middle_name]
      # u.title       = user_hash[:title] 
      # u.address_line1, u.address_line2, u.address_line3 = user_hash[:address].split("\n")
      # u.city         = user_hash[:city]
      # u.state        = user_hash[:state]
      # u.zip          = user_hash[:zip]
      # u.country      = user_hash[:country]
      # u.phone_number = user_hash[:phone_number]
      # u.netid        = user_hash[:username]
    end
  end
  # Find users in cc_pers
  # TODO: untested!
  def self.user_lookup(redis, study, netid, project_role, consent_role)
    user_alias = redis.hget("role:user_aliases", netid).downcase
    user = Pers::Person.find_by_username_or_id(netid.downcase)
    user = Pers::Person.find_by_username_or_id(user_alias) if user.blank?
    if user.blank?
      puts "Missing Netid = #{study} - #{netid} - #{project_role} - #{consent_role}"
      Resque.enqueue(IncompleteRoleProcessor, study, netid, project_role, consent_role)
      nil
    else
      return user.username
    end
    # if (user= User.find_by_netid(netid))
    #   user
    # elsif(user2=User.find_by_netid(netid.downcase))
    #   user2
    # elsif(user3 = User.find_by_netid(redis.hget("role:user_aliases", netid)))
    #   user3
    # elsif(user4 = User.find_by_netid(redis.hget("role:user_aliases", netid.downcase)))
    #   user4
    # else
    #   puts "Missing Netid = #{study} - #{netid} - #{project_role} - #{consent_role}"
    #   Resque.enqueue(IncompleteRoleProcessor, study, netid, project_role, consent_role)
    #   nil
    # end
  
  end
end