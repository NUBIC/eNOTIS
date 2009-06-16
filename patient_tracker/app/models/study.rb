require 'lib/webservices/webservices'

# Represents a Clinical Trial. Holds just the basic information we need
# for assigning subjects. The model holds the study number some basic information
# about the protocol (Title, PI, Description, Approval Date, etc) most of the data
# is pulled from the EDW (from the eIRB db export) as needed.

class Study < ActiveRecord::Base
	has_many :involvements
        has_many :study_rights
        has_many :users, :through => :study_rights
        has_many :subjects, :through => :involvements
	include WebServices

  $plugins= [EirbServices]
  def reconcile(params)
    #To Do
    #Reconciliations Process is as follows
    #0.Update Study
    #1.Obtain all involvements related to this protocol with status 'pending'
    #2.Check status of updated protocoli
    #3.If status is open: 
    #4.Alter every given involvement status according to protocol     
    Study.update(self.id,params)
    #self.involvements.each do |involvement|
     # if self.open? and !involvement.confirmed?
      #  involvement.confirmed!
      #end
    #end
    return self
    
  end
  

  def add_subject(subject)
     #To Do
     #Adding A subject uses the following logic
     #check that the protocol is open
     #check the status of both the protocol and
     if open?
       status = self.current?  and subject.current? #and subject.current?
       if !Involvement.find_by_study_id_and_subject_id(self.id,subject.id) 
         return Involvement.create(:study_id=>self.id,:subject_id=>subject.id,:confirmed=>status) 
       else
       end
     end
  end

  def open?
    return self.status == "open"
  end
  
  def current?
    return self.last_reconciled > 12.hours.ago
  end

  def authorized_user?(user)
    self.users.include?user
  end

end



