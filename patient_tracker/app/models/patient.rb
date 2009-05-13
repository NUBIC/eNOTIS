require 'EDWServices'
class Patient < ActiveRecord::Base.extend PatientRequests
	has_many :patient_mrns
	include PatientNode

end
