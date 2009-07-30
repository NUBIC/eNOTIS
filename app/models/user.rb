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
  attr_accessible :netid, :email, :first_name, :last_name
  
  # Public class methods
  def self.authenticate(netid, password)
    return nil if netid.blank? || password.blank?
    u = find_by_netid(netid.downcase)
    return u if u && (RAILS_ENV == 'development')
    self.setup_bcsec
    u && NetidAuthenticator.valid_credentials?(netid, password) ? u : nil
  end
  
  def self.authorize_entry(netid)
    u = find_by_netid(netid.downcase)
    u && !u.studies.empty?
  end
  
  def self.setup_bcsec
    yml = File.open(File.join(RAILS_ROOT,"config/bcsec.yml"))
    config = ServiceConfig.new(RAILS_ENV, YAML.parse(yml))
    ["ldap_server", "ldap_user", "ldap_password"].each{|option| Bcsec.send("#{option}=", config.send(option))}
  end

  # Public instance methods
  def netid=(value)
    write_attribute :netid, (value ? value.downcase : nil)
  end
  
  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def involvement_events
    # all involvement events on studies that this user has access to. refactored from invovlement_events_controller - yoon
    studies.map(&:involvements).flatten.map(&:involvement_events).flatten
  end
  
  # TODO set up a more robust role authorization system -yoon
  def admin?
    %w(blc615 daw286 myo628).include? self.netid
  end
  
  def name
    "#{self.first_name} #{self.last_name}"
  end
  
end
