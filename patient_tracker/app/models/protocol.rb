require 'lib/webservices/webservices'

# Represents a Clinical Trial. Holds just the basic information we need
# for assigning patients. The model holds the study number some basic information
# about the protocol (Title, PI, Description, Approval Date, etc) most of the data
# is pulled from the EDW (from the eIRB db export) as needed.

class Protocol < ActiveRecord::Base
	has_many :involvements
        has_many :user_protocols
	#include WebServices
  


  def authorized_user(user)
    UserProtocol.find_by_protocol_id_and_user_id(self.id,user.id)
  end

end



