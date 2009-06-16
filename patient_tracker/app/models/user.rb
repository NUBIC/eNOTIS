# User model for application context

class User < ActiveRecord::Base
  has_many :user_rights
  has_many :studies, :through => :user_rights
  attr_accessor :password #doesnt do anything for now
    
  # Rough validation method
  def self.find_and_validate(netid,password)
    u = User.find_by_netid(netid)
    u.authenticate(password) ? u : nil 
  end
 
  # Temporary implementation that will always return a user
  def self.find_by_netid(netid)
    User.find(:first, :conditions => ["netid =?", netid]) || User.create(:netid => netid)
  end
  
  def authenticate(password)
    #self.password == password  
    
    #This retrievs all data currently in the 
    
    #new_access_list = Studies.find_all_by_netid(netid)
    #old_access_list = self.studies
    #new_access_list.each do |study|
	#self.studies << study unless old_access_list.include?study
    #end
    true
  end
end
