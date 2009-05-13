class PatientOnProtocol < ActiveRecord::Base
  set_table_name :patients_on_protocols
  
	belongs_to :patient
	belongs_to :protocols 
  has_many :status_history, :class_name => "PatientOnProtocolStatus", :foreign_key => :patient_on_protocol_status_id
end
