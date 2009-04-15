class Patient < ActiveRecord::Base
	has_many :patient_mrns
end
