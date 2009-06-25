require 'webservices/plugins/eirb_services'

namespace :users do
  desc "Loads in all users from eIRB, creates them if they don't exist, updates them if they do"
  task :update_from_eirb => :environment do
    # get the user list
    users = EirbServices.find_all_users
    # iterate over the users creating or updating as neccessary
    
    users.each do |user_data| 
      u = User.find_by_netid(user_data[:netid])
      if u
        u.update_attributes(user_data)
        u.save
      else
        User.create(user_data)
      end
    end

  end

  desc "Loads in the users who are study coordinators"
  task :load_study_coordinators => :environment do
    # get the access list
    access = EirbServices.find_study_access
    access.each do |role|
      puts "Processing role #{role.inspect}"
      if study = Study.find(:first, :conditions => ["irb_number =?",role[:irb_number]],:span => :global)
        puts "Found study #{role[:irb_number]}"        
        study.save
        if user = User.find_by_netid(role[:netid])
          user.update_attributes(EirbServices.find_by_netid(user.netid))
        else
          user = User.create(EirbServices.find_by_netid(role[:netid]))
        end
        if user
          study.coordinators.create(:user_id => user.id)
          puts "Created coordinator #{user.netid}"
        else
          puts "Problem finding or creating user #{role[:netid]}"
        end
      else
        puts "Did NOT find study #{role[:irb_number]}"
      end
    end
  end

end
