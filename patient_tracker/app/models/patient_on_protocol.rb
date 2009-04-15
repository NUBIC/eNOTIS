class PatientOnProtocol < ActiveRecord::Base
	belongs_to :patient
	belongs_to :protocols 
end
