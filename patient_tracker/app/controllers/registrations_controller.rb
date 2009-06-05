class RegistrationsController < ApplicationController
  layout "layouts/loggedin"

  include AuthMod
  include FaceboxRender
  before_filter :user_must_be_logged_in

  # The registration landing page
  def index 
    @accessable_protocols = @current_user.protocols 
  end

  def show
   session[:study_id]= params[:id]
   @protocol = Protocol.find_by_irb_number(params[:id])
   @involvements = @protocol.involvements
  end

  def add_patient
    params[:study_id] = session[:study_id]
    @patient = Patient.find_by_mrn(params[:mrn])
    @protocol = Patient.find_by_study_id(session[:study_id])
    @protocol.add_patient(@patient)
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
      @patient = Patient.find_by_mrn(params[:mrn])
    end
    respond_to do |format|
      format.html
      format.js {render_to_facebox}
    end
  end

end
