# User model for application context
# Data for this model is loaded in from the eIRB 

class User < ActiveRecord::Base
  # Associations
  has_many :roles
  has_many :studies, :through => :roles

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
    return false if u.nil? && ((%w(development training).include? RAILS_ENV) or NetidAuthenticator.valid_credentials?(netid, password))
    nil
  end
  
  # Fills in data in postgres from the redis copy of the ldap server
  def self.update_from_redis
    UsersToPers.update_from_redis
    logger.warn "User.update_from_redis deprecated"
    # users = REDIS.keys 'user:*'
    # users.each do |redis_user|
    #   user_hash = HashWithIndifferentAccess.new(REDIS.hgetall(redis_user))
    #   ar_user = self.find_by_netid(redis_user.split(":")[1].downcase) || self.new
    #   ar_user.email       = user_hash[:email]
    #   ar_user.first_name  = user_hash[:first_name]
    #   ar_user.last_name   = user_hash[:last_name]
    #   ar_user.middle_name = user_hash[:middle_name]
    #   ar_user.title       = user_hash[:title] 
    #   ar_user.address_line1, ar_user.address_line2, ar_user.address_line3 = user_hash[:address].split("\n")
    #   ar_user.city         = user_hash[:city]
    #   ar_user.state        = user_hash[:state]
    #   ar_user.zip          = user_hash[:zip]
    #   ar_user.country      = user_hash[:country]
    #   ar_user.phone_number = user_hash[:phone_number]
    #   ar_user.netid        = user_hash[:username]
    #   unless ar_user.save
    #     puts "cant save #{user_hash[:username]}"
    #   end
    # end
  end
  # Returns netids absent from the User model
  # 
  # @param [Array] netids to check
  # @return [Array] netids absent from the User model
  def self.absent_netids(arr)
    logger.warn "User.absent_netids deprecated"
    # arr = arr.uniq.compact
    # arr - self.find_all_by_netid(arr).map(&:netid)
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
    %w(blc615 daw286 myo628 lmw351 wakibbe).include? self.netid
  end
  
  def name
    "#{self.first_name} #{self.last_name}"
  end

end
