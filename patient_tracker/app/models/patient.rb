# Represents a patient that has (at some point) been on a clinical trial protocol
# We store enough data to reconcile the local db store record with the patient data in 
# the EDW. The model stores the reconciliation fields and information about the source system
# for the data.
require 'lib/webservices/webservices'
class Patient < ActiveRecord::Base#.extend WebServices
  include WebServices
  has_many :involments
  has_many :patient_events



end
