class StudiesController < ApplicationController
  before_filter :user_must_be_logged_in
  layout "layouts/loggedin"

  def index
	  #@studies = Study.find_by_coordinator(params[:net_id])
  end
	
  def show
   @study = Study.find_by_id(params[:id])
   @subjects = Involvement.find_by_study_id(@study)
  end
	
  def search
    if @study = Study.find_by_irb_number(params[:study_id])
      render(:action => "show")
    else
      flash[:notice] = "No studies found"
      redirect_to :back
    end
  end

end
