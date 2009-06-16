# Stores all events around a subject and/or a subject on a protocol.
# Creates an event history of what things happen to a subject in the 
# context of a clinical trial.

class SubjectEvent < ActiveRecord::Base
  belongs_to :subject
  belongs_to :protocol

  validates_presence_of :status
  validates_presence_of :status_date
 
end
