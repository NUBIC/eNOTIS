class StudiesController < ApplicationController
include AuthMod
before_filter :user_must_be_logged_in
layout "layouts/loggedin"

  def index
	  #@studies = Study.find_by_coordinator(params[:net_id])
  end
	
  def show
   @protocol = Study.find_by_study_id(params[:id])
   @subjects = Involvement.find_by_protocol_id(@protocol)
  end
	
  def search
    @protocol =  Study.find_by_irb_number(params[:study_id])
    render(:action => "show")
  end

end