class RegistrationsController < ApplicationController
  layout "layouts/loggedin"

  include AuthMod
  include FaceboxRender
  before_filter :user_must_be_logged_in

  # The registration landing page
  def index 
    @accessable_protocols = UserProtocol.find_all_by_user_id(@current_user.id)
  end

  def show
   session[:study_id]= params[:id]
   @protocol = Protocol.find_by_irb_number(params[:id])
   @involvements = Involvement.find(:all,:conditions=>["protocol_id = ?",@protocol.id]) unless @protocol.nil?
  end

  def add_patient
    params[:study_id] = session[:study_id]
    Involvement.add_patient_to_protocol(params)
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
      @involvements = Involvement.find_all_by_patient_id(@patient.id)
    end
    respond_to do |format|
      format.html
      format.js {render_to_facebox}
    end
  end

end
