require 'lib/webservices/webservices'

# Represents a Clinical Trial. Holds just the basic information we need
# for assigning patients. The model holds the study number some basic information
# about the protocol (Title, PI, Description, Approval Date, etc) most of the data
# is pulled from the EDW (from the eIRB db export) as needed.

class Protocol < ActiveRecord::Base
	has_many :involvements
        has_many :user_protocols
        has_many :users, :through => :user_protocols
        has_many :patients, :through => :involvements
	include WebServices

  $plugins= [EirbService]
  def reconcile(params)
    #To Do
    #Reconciliations Process is as follows
    #0.Update Protocol
    #1.Obtain all involvements related to this protocol with status 'pending'
    #2.Check status of updated protocoli
    #3.If status is open: 
    #4.Alter every given involvement status according to protocol     
    Protocol.update(self.id,params)
    self.involvements.each do |involvement|
      if self.open? and !involvement.confirmed?
        involvement.confirmed!
      end
    end
    
  end
  

  def add_patient(patient)
     #To Do
     #Adding A patient uses the following logic
     #check that the protocol is open
     #check the status of both the protocol and
     if open?
       status = self.current?  and patient.current? #and patient.current?
       if !Involvement.find_by_protocol_id_and_patient_id(self.id,patient.id) 
         return Involvement.create(:protocol_id=>self.id,:patient_id=>patient.id,:confirmed=>status) 
       else
       end
     end
  end

  def open?
    return self.status == "open"
  end
  
  def current?
    return self.reconciliation_date > 12.hours.ago
  end

  def authorized_user?(user)
    self.users.include?user
  end

end



