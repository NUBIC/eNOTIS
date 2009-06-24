require 'webservices/plugins/eirb_services'

namespace :users do
  desc "Loads in all users from eIRB, creates them if they don't exist, updates them if they do"
  task :update_from_eirb do
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
  task :load_study_coordinators do
    # get the access list
    access = EirbServices.find_study_access
    puts access.first.inspect
    
  end

end
