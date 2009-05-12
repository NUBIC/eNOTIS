class User < ActiveRecord::Base

  # Rough validation method
  def self.validate_user(netid,password)
    u = User.find_by_netid(netid)
    if u and u.authenticate(password)
      u
    else
      nil
    end
  end
 
  # Temporary implementation that will always return a user
  def self.find_by_netid(netid)
    User.create(:netid => netid)
  end
  
  def authenticate(password)
    self.password == password  
  end
end
