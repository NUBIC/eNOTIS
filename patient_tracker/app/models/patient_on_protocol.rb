class PatientOnProtocol < ActiveRecord::Base
	belongs_to :patient
	belongs_to :protocols 
  has_one :status, :class_name => "PatientOnProtocolStatus", :foreign_key => :patient_on_protocol_status_id
end
