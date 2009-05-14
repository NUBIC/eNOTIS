require 'EDWServices'
class Patient < ActiveRecord::Base.extend PatientRequests
	include PatientNode

end
