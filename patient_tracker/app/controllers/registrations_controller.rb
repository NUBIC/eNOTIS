class RegistrationsController < ApplicationController
  layout "layouts/loggedin"

  include AuthMod
  include FaceboxRender
  before_filter :user_must_be_logged_in

  # The registration landing page
  def index 
    @accessable_studies = @current_user.studies 
  end

  def show
   session[:study_id]= params[:id]
   @study = Study.find_by_irb_number(params[:id])
   @involvements = @study.involvements
  end

  def add_subject
    params[:study_id] = session[:study_id]
    @subject = Subject.find_by_mrn(params[:mrn])
    @study = Subject.find_by_study_id(session[:study_id])
    @study.add_subject(@subject)
    respond_to do |format|
      format.html
      format.js {render_to_facebox}
    end	
	
  end  

  def new
    respond_to do |format|
      format.html
      format.js {render_to_facebox}
    end	
	
  end  
  
  def search
    if not params[:no_mrn]
      @subject = Subject.find_by_mrn(params[:mrn])
    end
    respond_to do |format|
      format.html
      format.js {render_to_facebox}
    end
  end

end
