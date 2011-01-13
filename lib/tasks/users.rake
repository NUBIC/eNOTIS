require 'webservices'

namespace :users do
  
  desc "Loads users in roles table by netID to CC_pers"
  task :update_cc_pers do
    Role.find(:first).each do |role|
      user = Bcsec.authority.find_user(role.netid)
      if user
        UsersToPers.insert_user_into_cc_pers(role.netid, {:first_name => user.first_name, :last_name => user.last_name, :email => user.email})
        puts "Added/updated #{role.netid}"
      else
        puts "Did not find user #{role.netid} in Bcsec authority lookup. This could be a bad netid"
      end
    end
  end

  desc "Loads in all users from eIRB, creates them if they don't exist, updates them if they do"
  task :update_from_eirb => :environment do
    raise "update_from_eirb deprecated"
    # # get the user list
    # users = Eirb.find_all_users
    # # iterate over the users creating or updating as neccessary
    # 
    # users.each do |user_data| 
    #   u = User.find_by_netid(user_data[:netid])
    #   if u
    #     u.update_attributes(user_data)
    #     u.save
    #   else
    #     User.create(user_data)
    #   end
    # end

  end

  desc "Loads in the users who are study coordinators"
  task :load_study_coordinators => :environment do
    raise "load_study_coordinators deprecated"
    # # get the access list
    # access = Eirb.find_study_access
    # access.each do |role|
    #   puts "Processing role #{role.inspect}"
    #   if study = Study.find(:first, :conditions => "irb_number ='#{role[:irb_number]}'",:span => :global)
    #     puts "Found study #{role[:irb_number]}"        
    #     study.save
    #     unless user = User.find_by_netid(role[:netid])
    #       user_hash = Eirb.find_by_netid({:netid => role[:netid]}).first
    #       puts user_hash.inspect
    #       user = User.create(user_hash)
    #     end
    #     if user
    #       study.coordinators.create(:user_id => user.id)
    #       puts "Created coordinator #{user.netid}"
    #     else
    #       puts "Problem finding or creating user #{role[:netid]}"
    #     end
    #   else
    #     puts "Did NOT find study #{role[:irb_number]}"
    #   end
    # end
  end

  desc "finds just one user"
  task :test => :environment do
    raise "test deprecated"
    # user_hash = Eirb.find_by_netid({:netid => "KAY668"}).first
    # puts user_hash[:email].methods.sort
    # puts user_hash[:email].to_s
    # puts user_hash.inspect
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
