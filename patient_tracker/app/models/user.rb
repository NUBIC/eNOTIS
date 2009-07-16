# User model for application context
# Data for this model is loaded in from the eIRB 

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByNetid
 
  # Associations
  has_many :coordinators
  delegate :as_coordinator, :to => :coordinators #so we can use the syntax user.as_coordinator.studies
  has_many :studies, :through => :coordinators

  # Mixins
  has_paper_trail
    
  # Validators
  validates_presence_of     :netid
  validates_uniqueness_of   :netid

  attr_accessible :netid, :email, :first_name, :last_name, :password
  
  def self.authenticate(netid, password)
    return nil if netid.blank? || password.blank?
    u = find_by_netid(netid.downcase)
    u && u.authenticated?(password) ? u : nil
  end
  
  def self.authorize_entry(netid)
    u = find_by_netid(netid.downcase)
    u && !u.studies.empty?
  end
  
  def netid=(value)
    write_attribute :netid, (value ? value.downcase : nil)
  end
  
  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def admin?
    %w(blc615 daw286 myo628).include? self.netid
  end
  
  def name
    "#{self.first_name} #{self.last_name}"
  end
  
end
