require 'lib/webservices/webservices'

# Represents a Clinical Trial. Holds just the basic information we need
# for assigning subjects. The model holds the study number some basic information
# about the study (Title, PI, Description, Approval Date, etc) most of the data
# is pulled from the EDW (from the eIRB db export) as needed.

# Possible eIRB statuses
# 
# Approval Correspondence Review
# Approved
# Assigned to Meeting
# Assigned to Meeting: Changes Requested
# Awaiting Approval Correspondence
# Awaiting Coordinator Assignment
# Awaiting Meeting Assignment
# Chair Correspondence Review
# Changes Requested by Dept Reviewer
# Changes Requested By OPRS Staff
# Changes Required by IRB
# Closed/Terminated
# Completed
# Conditional Approval
# Correspondence Review: PCH or DR
# Dept Site Anc Review
# Designated Reviewer Conditions Review
# Exempt Approval Revoked
# Exempt Approved
# Exempt Correspondence Review
# Exempt Review: Awaiting Approval Correspondence
# Exempt Review: Awaiting Correspondence
# Exempt Review: Changes Requested
# Expedited Review: Awaiting Correspondence
# Expedited Review: Changes Requested
# Expired
# Expired: Periodic Review In Progress
# In Exempt Review
# In Expedited Review
# Meeting Complete Awaiting Correspondence
# Not Under IRB Purview
# OPRS Staff Conditions Review
# OPRS Staff Review
# Original Version
# Pre Submission
# Rejected
# Revision Closed
# Revision Open
# Suspended
# Withdrawn

class Study < ActiveRecord::Base
	has_many :involvements
  has_many :coordinators
  has_many :subjects, :through => :involvements
  has_many :study_uploads
  has_paper_trail
	include WebServices

  validates_presence_of :synced_at, :irb_number
  
  $plugins= [EirbServices]
  
  def to_param
    self.irb_number
  end
  
  def add_subject(subject)
    involvements.find_by_subject_id(subject.id) || involvements.create(:subject_id => subject.id)
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
  def documents
    []
  end
  def may_accrue?
    # returns false if self.status.nil?
    ["Approved", "Conditional Approval", "Exempt Approved", "Not Under IRB Purview", "Revision Open"].include? self.status
  end
  def accrual
    involvements.size
  end
  
end



