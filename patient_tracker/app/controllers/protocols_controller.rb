class ProtocolsController < ApplicationController
  
  def index
	  @protocols = Protocol.find_by_coordinator(params[:net_id])
	end
	
	def show
	  @protocol = Protocol.find_by_study_id(params[:study_id])
	end
	
  def search
    @protocols = Protocol.find_by_study_id(params[:study_id])
  end
end
