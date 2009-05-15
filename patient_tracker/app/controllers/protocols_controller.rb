class ProtocolsController < ApplicationController
include AuthMod
before_filter :user_must_be_logged_in
layout "layouts/loggedin"

  def index
	  @protocols = Protocol.find_by_coordinator(params[:net_id])
	end
	
  def show
   @protocol = Protocol.find_by_study_id(params[:id])
   @patients = Involvement.find_by_protocol_id(@protocol)
  end
	
  def search
    @protocols = Protocol.find_by_study_id(params[:study_id])
    render(index)
  end

end
