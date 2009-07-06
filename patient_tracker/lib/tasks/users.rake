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
      if study = Study.find(:first, :conditions => "irb_number ='#{role[:irb_number]}'",:span => :global)
        puts "Found study #{role[:irb_number]}"        
        study.save
        unless user = User.find_by_netid(role[:netid])
          user_hash = EirbServices.find_by_netid({:netid => role[:netid]}).first
          puts user_hash.inspect
          user = User.create(user_hash)
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

  desc "finds just one user"
  task :test => :environment do
    user_hash = EirbServices.find_by_netid({:netid => "KAY668"}).first
    puts user_hash[:email].methods.sort
    puts user_hash[:email].to_s
    puts user_hash.inspect
  end

  desc "creates the admin users"
  task :create_admins => :environment do
    admins = {
      :blc615 => {:fn => "Brian",:ln => "Chamberlain",:e => "b-chamberlain@northwestern.edu"}, 
      :daw286 => {:fn => "David",:ln => "Were",:e => "d-were@northwestern.edu"},
      :myo628 => {:fn => "Mark",:ln => "Yoon",:e => "yoon@northwestern.edu"}
    }

    admins.each do |k,u|
      unless User.find_by_netid(k.to_s)
        User.create(:netid => k.to_s, :first_name => u[:fn], :last_name => u[:ln], :email => u[:e])
        puts "Created #{k}"       
      else
        puts "#{k} already exists"
      end
    end
  end


end
