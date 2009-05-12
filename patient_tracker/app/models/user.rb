class User < ActiveRecord::Base

  def self.validate_user(netid,password)
    u = User.find_by_netid(netid)
    if u and u.authenticate(password)
      u
    else
      nil
    end
  end
  
  def self.find_by_netid(netid)
    #dummy method
  end
  
  def authenticate(password)
    self.password == password  
  end
end
