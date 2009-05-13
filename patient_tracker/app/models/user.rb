class User < ActiveRecord::Base

  attr_accessor :password #doesnt do anything for now
    
  # Rough validation method
  def self.validate_user(netid,password)
    u = User.find_by_netid(netid)
  end
 
  # Temporary implementation that will always return a user
  def self.find_by_netid(netid)
    User.find(:first, :conditions => ["netid =?", netid]) || User.create(:netid => netid)
  end
  
  def authenticate(password)
    self.password == password  
  end
end
