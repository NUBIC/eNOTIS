require 'EDWServices'
class Patient < ActiveRecord::Base.extend PatientRequests
	include PatientNode
	has_many :involments
	has_many :patient_events

end
