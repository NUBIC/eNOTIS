module UsersToPers
  # should match Bcsec.configuration.portal in config/initializers/bcsec.rb
  PORTAL = "eNOTIS"
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

end