class StudiesController < ApplicationController
  before_filter :user_must_be_logged_in
  layout "main"

  def index
    @studies = Study.all || []
  end
	
  def show
    session[:study_id]= params[:id]
    @study = Study.find_by_id(params[:id])
  end
	
  def search
    if params[:query] and @study = (Study.find_by_irb_number(params[:query]) || Study.find(:first, :conditions => [ "title like ?", "%#{params[:query]}%"]) )
      render(:action => "show")
    else
      flash[:notice] = "No studies found"
      redirect_to :back
    end
  end

end
