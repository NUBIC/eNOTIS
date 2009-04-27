#This class represents protocols in Eirb

class EirbProtocol
	attr_accessor :title, :description
	def initialize(title,description)
		@title = title
		@description = description
	end

	def find_all()
	#To Do
	end

	def self.find_by_eirb_number(eirb_number)
	#To Do
	 #need to delete this garbage once we get eirb serveices up and running
	 EirbProtocol.new("protocol1","This is some prototocol")
	end

end
