class ProtocolController < ApplicationController

	def index
		#some garbage I need to delete
		protocol1 = EirbProtocol.new("protocol1","This is some prototocol")
		protocol2 = EirbProtocol.new("protocol2","This is another protocol")
		@protocols=[protocol1,protocol2]		
	end
	
	def show
		@protocol = EirbProtocol.find_by_eirb_number('test')
		#@patients = EdwPatients.find_by_protocol(@protocol)
	end
end
