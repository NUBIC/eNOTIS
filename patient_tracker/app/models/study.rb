require 'lib/webservices/webservices'

# Represents a Clinical Trial. Holds just the basic information we need
# for assigning subjects. The model holds the study number some basic information
# about the study (Title, PI, Description, Approval Date, etc) most of the data
# is pulled from the EDW (from the eIRB db export) as needed.

class Study < ActiveRecord::Base
	has_many :involvements
  has_many :coordinators
  has_many :subjects, :through => :involvements
  has_paper_trail
	include WebServices

  validates_presence_of :synced_at
  
  $plugins= [EirbServices]

  def add_subject(subject)
     Involvement.create(:study_id => self.id, :subject_id => subject.id) unless Involvement.find_by_study_id_and_subject_id(self.id,subject.id) 
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

  # def authorized_user?(user)
  #   self.users.include?user
  # end

end



