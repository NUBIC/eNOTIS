
# Represents the very strong to very loose affiliation a patient can have with a protocol.
# This abstraction holds data that is associated with a patients relationship with a protocol
# but is not based around a protocol event. 
# For example: Disease site would be found in the Inolvement join record between a patient and protocol.
# Disease site is a specific piece of data about why the patient is on the trial but not associated with
# a specific event. It is a long term data element that can span the whole relationship of patient and protocol.

class Involvement < ActiveRecord::Base
	belongs_to :patient
	belongs_to :protocol

  def self.add_patient_to_protocol(params)
    protocol = Protocol.find_by_irb_number(params[:study_id])
    if params[:mrn]
      patient = Patient.find_by_mrn(params[:mrn])
    else
      patient = Patient.create( {:first_name => params[:first_name],:last_name=> params[:last_name]})
      #patient.save
    end
    involvement = Involvement.create ({:protocol_id => protocol.id, :patient_id => patient.id})
    #involvement.save    
  end
end
