require 'EDWServices'
class Patient < ActiveRecord::Base.extend PatientRequests
	has_many :patient_mrns
	has_many :involments
	has_many :patient_events
	include PatientNode
end
