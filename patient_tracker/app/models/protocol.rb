require 'lib/Edwservices'

# Represents a Clinical Trial. Holds just the basic information we need
# for assigning patients. The model holds the study number some basic information
# about the protocol (Title, PI, Description, Approval Date, etc) most of the data
# is pulled from the EDW (from the eIRB db export) as needed.

class Protocol < ActiveRecord::Base.extend ProtocolRequests
include ProtocolNode

end



