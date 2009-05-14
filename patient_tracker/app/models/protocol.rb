require 'lib/Edwservices'

class Protocol < ActiveRecord::Base.extend ProtocolRequests
	has_many :involvements
	include ProtocolNode
end
