require 'lib/Edwservices'

class Protocol < ActiveRecord::Base.extend ProtocolRequests
#@xml_node=nil
include ProtocolNode
end
