class PatientOnProtocol < ActiveRecord::Base
	belongs_to :patient
	belongs_to :protocols 
  has_one :status, :class_name => "PatientStatus", :foreign_key => :patient_status_id"
end
