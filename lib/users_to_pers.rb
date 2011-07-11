module UsersToPers
  PORTAL = "eNOTIS" # should match Bcsec.configuration.portal in config/initializers/bcsec.rb

  # Creates the eNOTIS portal as well as Admin and User groups in cc_pers
  def self.setup
    unless enotis = Pers::Portal.find_by_name(PORTAL)
      enotis = Pers::Portal.new
      enotis.portal = PORTAL
      enotis.save
    end
    %w(Admin User Temp).each do |gn|
      enotis.groups.create(:group_name => gn) unless enotis.groups.find_by_group_name(gn)
    end
  end
  # Creates eNOTIS developers and admins in cc_pers
  def self.create_admins
    YAML.load_file("/etc/nubic/enotis-#{RAILS_ENV}-users.yml")['admin'].each do |a|
      unless Pers::Person.find_by_username(a['netid'])
        Pers::Person.create(
          :username => a['netid'], :first_name => a['first_name'], :last_name => a['last_name'],
          :entered_by => "enotis-application"
          )
      end
      unless Pers::Login.find_by_username_and_portal(a['netid'], PORTAL)
        login = Pers::Login.new
        login.username = a['netid']
        login.portal_name = PORTAL # can't be bulk set
        login.save
      end
      puts "updated/created #{a['netid']} as admin"
      %w(Admin User).each do |group|
        unless Pers::GroupMembership.find_by_username_and_portal_and_group_name(a['netid'], PORTAL, group)
          Pers::GroupMembership.create(:username => a['netid'], :group_name => group, :portal => PORTAL)
        end
      end
    end
  end

  # Creates eNOTIS temps in cc_pers
  def self.create_temps
    YAML.load_file("/etc/nubic/enotis-#{RAILS_ENV}-users.yml")['temp'].each do |a|
      unless Pers::Person.find_by_username(a['netid'])
        Pers::Person.create(
          :username => a['netid'], :first_name => a['first_name'], :last_name => a['last_name'],
          :entered_by => "enotis-application"
          )
      end
      unless Pers::Login.find_by_username_and_portal(a['netid'], PORTAL)
        login = Pers::Login.new
        login.username = a['netid']
        login.portal_name = PORTAL # can't be bulk set
        login.save
      end
      puts "updated/created #{a['netid']} as temp"
      %w(Temp User).each do |group|
        unless Pers::GroupMembership.find_by_username_and_portal_and_group_name(a['netid'], PORTAL, group)
          Pers::GroupMembership.create(:username => a['netid'], :group_name => group, :portal => PORTAL)
        end
      end
    end
  end

  def self.insert_user_into_cc_pers(netid, attrs, role = "User")
    Bcaudit::AuditInfo.current_user = Bcsec.authority.find_user('blc615')
    unless Pers::Person.find_by_username_or_id(netid)
      u = Pers::Person.new(attrs.merge({:username => netid, :entered_by => "enotis-application"}))
      if u.save
        puts "person saved - #{netid} "
      else
        puts "person not saved - #{netid} (#{u.errors.full_messages}) "
      end
    end
    unless Pers::Login.find_by_username_and_portal(netid, PORTAL)
        login = Pers::Login.new
        login.username = netid
        login.portal_name = PORTAL # can't be bulk set
        if login.save
          puts "login saved - #{netid} eNOTIS"
        else
          puts "login not saved - #{netid} eNOTIS (#{login.errors.full_messages})"
        end
    end
    unless Pers::GroupMembership.find_by_username_and_portal_and_group_name(netid, PORTAL, role)
      gm = Pers::GroupMembership.create(:username => netid, :group_name => role, :portal => PORTAL)
      if gm.save
        puts "group membership saved - #{netid} eNOTIS #{role}"
      else
        puts "group membership not savedd - #{netid} eNOTIS #{role} (#{gm.errors.full_messages})"
      end
    end
  end

  # Find users in cc_pers
  # TODO: untested!
  def self.user_lookup(redis, study, netid, project_role, consent_role)
    user_alias = redis.hget("role:user_aliases", netid).to_s.downcase
    user = Pers::Person.find_by_username_or_id(netid.downcase)
    user = Pers::Person.find_by_username_or_id(user_alias) if user.blank?
    if user.blank?
      puts "Missing Netid = #{study} - #{netid} - #{project_role} - #{consent_role}"
      Resque.enqueue(IncompleteRoleProcessor, study, netid, project_role, consent_role)
      nil
    else
      return user.username
    end
  end
end
