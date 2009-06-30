class StudiesController < ApplicationController
  before_filter :user_must_be_logged_in
  layout "main"

  def index
    @studies = Study.all || []
  end
	
  def show
    @study = Study.find_by_id(params[:id])
  end
	
  def search
    if @study = ( Study.find_by_irb_number(params[:study_id]) || Study.find(:first, :conditions => [ "title like ?", "%#{params[:study_id]}%"]) )
      render(:action => "show")
    else
      flash[:notice] = "No studies found"
      redirect_to :back
    end
  end

end
