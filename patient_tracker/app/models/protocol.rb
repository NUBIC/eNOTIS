require 'lib/Edwservices'

# Represents a Clinical Trial. Holds just the basic information we need
# for assigning patients. The model holds the study number some basic information
# about the protocol (Title, PI, Description, Approval Date, etc) most of the data
# is pulled from the EDW (from the eIRB db export) as needed.

class Protocol < ActiveRecord::Base.extend ProtocolRequests
	has_many :involvements
	include ProtocolNode
  
  attr_accessor :xml_node

  def initialize(xml)
    @xml_node = xml
  end

  def self.save_foreign_protocol(protocol)
    new_protocol = Protocol.new(protocol)
    new_protocol.irb_number = protocol.study_id
    new_protocol.save
    return new_protocol
  end  
end



