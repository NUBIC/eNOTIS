
require 'couchrest'

# Represents a Clinical Study/Trial.
class Study < ActiveRecord::Base

  COUCH_DB = "http://127.0.0.1:5948/eirb_012110"
  
  # Associations
  has_many :involvements
  has_many :coordinators
  has_many :subjects, :through => :involvements
  has_many :study_uploads 
  
  # Validators
  validates_format_of :irb_number, :with => /^STU.+/, :message => "invalid study number format"

  attr_accessor :eirb_json

  def after_initialize
    self.eirb_json = "{:foo =>'bar'}"
  end

  # irb_number instead of id in urls
  def to_param
    self.irb_number
  end
  
  def has_coordinator?(user)
    user.admin? or coordinators.map(&:user).include? user
  end

  def can_accrue?
    # For possible eIRB statuses, see doc/terms.csv
    ["Approved", "Exempt Approved", "Not Under IRB Purview", "Revision Closed", "Revision Open"].include? self.status
  end
  
end



