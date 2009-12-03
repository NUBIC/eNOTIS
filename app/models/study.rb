require 'webservices/webservices'

# Represents a Clinical Study/Trial. Holds just the basic information we need
# for assigning subjects. The model holds the study number, some basic information
# about the study (Title, PI, Description, Approval Date, etc.). Most of the data
# is pulled from the EDW (from the eIRB db export) as needed.

class Study < ActiveRecord::Base
  
  # Associations
  has_many :involvements
  has_many :coordinators
  has_many :subjects, :through => :involvements
  has_many :study_uploads

  # Mixins
  has_paper_trail
  include WebServices
  self.plugins=[EirbServices]
  
  # Validators
  validates_presence_of :synced_at, :irb_number
  
  
  # Public instance methods
  
  # irb_number instead of id in urls
  def to_param
    self.irb_number
  end
  
  def add_subject(subject,params)
    involvements.find_by_subject_id(subject.id) || involvements.create(:subject_id => subject.id,:ethnicity_type_id=>params[:ethnicity],:gender_type_id=>params[:gender])
  end

  def open?
    self.status == "open"
  end
  
  def stale?
    self.synced_at < 12.hours.ago # assumed synced is never nil
  end
  
  def sync!(attrs)
    self.update_attributes(attrs.merge({:synced_at => DateTime.now}))
    return self
  end
  
  def has_coordinator?(user)
    user.admin? or coordinators.map(&:user).include? user
  end
  

  def may_accrue?
    # For possible eIRB statuses, see doc/terms.csv
    ["Approved", "Exempt Approved", "Not Under IRB Purview", "Revision Closed", "Revision Open"].include? self.status
  end
  
  def accrual
    involvements.size
  end

  def self.find_by_irb_number(irb_number)
    find(:first,:conditions=>{:irb_number=>irb_number},:span=>:global)
  end

  
end



