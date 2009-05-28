# User model for application context

class User < ActiveRecord::Base
  has_many :user_protocols
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
    true
  end
end
