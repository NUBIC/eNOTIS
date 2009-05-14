class ProtocolController < ApplicationController
 
  def index
   @protocols = Protocol.find_by_coordinator(params[:netid])
  end
  
  def show
   @protocol = Protocol.find_by_study_id(params[:study_id])
   @patients = Involvement.find_by_protocol_id(@protocol)
  end
  
end
