class ServiceForm < ActiveRecord::Base
  has_many :service_procedures  
  belongs_to :study
end
