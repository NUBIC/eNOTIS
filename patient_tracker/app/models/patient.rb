# Represents a patient that has (at some point) been on a clinical trial protocol
# We store enough data to reconcile the local db store record with the patient data in 
# the EDW. The model stores the reconciliation fields and information about the source system
# for the data.
require 'lib/webservices/webservices'
class Patient < ActiveRecord::Base #.extend WebServices
  include WebServices
  has_many :involvements
  has_many :patient_events 
  has_many :protocols, :through => :involvements

  $plugins = [EdwService]



  def reconcile(values)
    values[:last_reconciled]=Time.now
    Patient.update(self.id,values)  
  end

  def current?
   self.last_reconciled > 12.hours.ago unless last_reconciled.nil?
  end

  def confirmed!
    self.reconciled = true
    self.save
  end

  def confirmed?
    self.reconciled
  end 

end
