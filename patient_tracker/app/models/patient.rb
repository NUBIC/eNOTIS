# Represents a patient that has (at some point) been on a clinical trial protocol
# We store enough data to reconcile the local db store record with the patient data in 
# the EDW. The model stores the reconciliation fields and information about the source system
# for the data.

require 'EDWServices'
class Patient < ActiveRecord::Base.extend PatientRequests
	include PatientNode
	has_many :involments
	has_many :patient_events

  attr_accessor :xml_node

  def initialize(xml)
   @xml_node = xml 
  end

  
  def self.save_foreign_patient(patient)
    new_patient = Patient.new
    new_patient.first_name = patient.first_name
    new_patient.last_name = patient.last_name
    new_patient.save
  end

end
