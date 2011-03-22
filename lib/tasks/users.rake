require 'webservices'

namespace :users do
  
  desc "Loads users in roles table by netID to CC_pers"
  task :update_cc_pers => :environment do
    Bcaudit::AuditInfo.current_user = Bcsec::User.new("enotis-application")
    roles = Role.find(:all)
    roles.map(&:netid).uniq.each do |netid|
      user = Bcsec.authority.find_user(netid)
      if user
        UsersToPers.insert_user_into_cc_pers(netid, {:first_name => user.first_name, :last_name => user.last_name, :email => user.email})
        print "."
        STDOUT.flush
      else
        puts "Did not find user #{netid} in Bcsec authority lookup. This could be a bad netid"
      end
    end
  end
  
  desc "creates the enotis-application user"
  task :create_appuser => :environment do
    Bcaudit::AuditInfo.current_user = Bcsec::User.new('myo628')
    Pers::Person.create!(:username => "enotis-application", :first_name => "enotis", :last_name => "application", :entered_by => "myo628")
  end
  
  # rake db:populate:admins depends on this rake task
  desc "creates the admin users"
  task :create_admins => :environment do
    Bcaudit::AuditInfo.current_user = Bcsec::User.new('enotis-application')
    UsersToPers.setup
    UsersToPers.create_admins
  end
 
  # What is this used for? The netids are not correct.
  desc "creates non-admin users"
  task :create_non_admins => :environment do
    nons = [{:netid => "brian", :first_name => "Brian",   :last_name => "Chamberlain",     :email => "b-chamberlain@northwestern.edu"}, 
              {:netid => "david", :first_name => "David",   :last_name => "Were",            :email => "d-were@northwestern.edu"},
              {:netid => "laura", :first_name => "Laura",   :last_name => "Wimbiscus Yoon",  :email => "laurawimbiscus2008@u.northwestern.edu"},
              {:netid => "yoon", :first_name => "Mark",    :last_name => "Wimbiscus Yoon",  :email => "yoon@northwestern.edu"}]
    nons.each do |hash|
      User.create(hash) unless (exists = User.find_by_netid(hash[:netid]))
      puts exists ? "#{hash[:netid]} already exists" : "Created #{hash[:netid]}"
    end
  end

end
