# User model for application context

class User < ActiveRecord::Base
  has_many :coordinators
  delegate :as_coordinator, :to => :coordinators #so we can use the syntax user.as_coordinator.studies
  has_many :studies, :through => :coordinators
  has_paper_trail
  attr_accessor :password # useful for testing

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :netid, :email, :first_name, :last_name, :password
    
  include Authentication
  include Authentication::ByNetid
  
  # validates_presence_of     :netid
  # validates_length_of       :netid,    :within => 1..10
  # validates_uniqueness_of   :netid
  # validates_format_of       :netid,    :with => Authentication.netid_regex, :message => Authentication.bad_netid_message
  # validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  # validates_length_of       :name,     :maximum => 100
  # validates_presence_of     :email
  # validates_length_of       :email,    :within => 6..100 #r@a.wk
  # validates_uniqueness_of   :email
  # validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
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
  #   # Rough validation method
  #   def self.find_and_validate(netid,password)
  #     u = User.find_by_netid(netid)
  #     u.authenticate(password) ? u : nil 
  #   end
  #  
  #   # Temporary implementation that will always return a user
  #   def self.find_by_netid(netid)
  #     User.find(:first, :conditions => ["netid =?", netid]) || User.create(:netid => netid)
  #   end
  #   
  #   def authenticate(password)
  #     #self.password == password  
  #     
  #     #This retrievs all data currently in the 
  #     
  #     #new_access_list = Studies.find_all_by_netid(netid)
  #     #old_access_list = self.studies
  #     #new_access_list.each do |study|
  # #self.studies << study unless old_access_list.include?study
  #     #end
  #     true and !self.studies.empty?
  #   end

  protected
  
  
end
