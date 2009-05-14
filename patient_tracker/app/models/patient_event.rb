# Stores all events around a patient and/or a patient on a protocol.
# Creates an event history of what things happen to a patient in the 
# context of a clinical trial.

class PatientEvent < ActiveRecord::Base
  belongs_to :patient
  belongs_to :protocol

  validates_presence_of :status
  validates_presence_of :status_date
 
end
