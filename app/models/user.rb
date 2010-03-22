# User model for application context
# Data for this model is loaded in from the eIRB 

class User < ActiveRecord::Base
  # Associations
  has_many :coordinators
  delegate :as_coordinator, :to => :coordinators #so we can use the syntax user.as_coordinator.studies
  has_many :studies, :through => :coordinators

  # Mixins
  include Bcsec
  has_paper_trail
    
  # Validators
  validates_presence_of     :netid
  validates_uniqueness_of   :netid

  # Attributes
  attr_accessible :netid, :email, :first_name, :last_name, :middle_name, :title, :address_line1, :address_line2, :address_line3, :city, :state, :zip, :country, :phone_number
  # attributes from eirb, not on this list or in db: fax_number, eirb_create_date
  
  # Public class methods
  
  # Authenticates a user by netid and password
  # 
  # @param [String] netid Northwestern netID for user
  # @param [String] password password for user
  # @return [User, false, nil] User if user exists and in dev mode or user is authenticated, false if user doesn't exist and is authenticated, nil if not authenticated
  def self.authenticate(netid, password)
    return nil if netid.blank? || password.blank?
    u = find_by_netid(netid.downcase)
    # logger.debug("RAILS_ENV=#{RAILS_ENV}")
    # bypass netid authentication in development
    return u if u && ((%w(development training).include? RAILS_ENV) or NetidAuthenticator.valid_credentials?(netid, password))
    return false if u.nil? && NetidAuthenticator.valid_credentials?(netid, password)
    nil
  end
  
  # Returns netids absent from the User model
  # 
  # @param [Array] netids to check
  # @return [Array] netids absent from the User model
  def self.absent_netids(arr)
    arr = arr.uniq.compact
    arr - self.find_all_by_netid(arr).map(&:netid)
  end
  
  # Public instance methods
  def netid=(value)
    write_attribute :netid, (value ? value.downcase : nil)
  end
  
  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def involvement_events
    # all involvement events on studies that this user has access to. refactored from involvement_events_controller - yoon
    # involvements.map(&:involvement_events).flatten
    InvolvementEvent.on_studies(studies)
  end
  
  def involvements
    # all subjects on studies that this user has access to. refactored from subjects_controller
    Involvement.with_coordinator(self)
    # studies.map(&:involvements).flatten
  end
  
  def subjects
    Subject.on_studies(studies)
  end
  
  # TODO set up a more robust role authorization system -yoon
  def admin?
    %w(blc615 daw286 myo628 lmw351 sjg304).include? self.netid
  end
  
  def name
    "#{self.first_name} #{self.last_name}"
  end
  
end
