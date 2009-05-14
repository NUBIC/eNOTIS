class PatientEvent < ActiveRecord::Base
  belongs_to :patient
  belongs_to :protocol

  validates_presence_of :status
  validates_presence_of :status_date
 
end
