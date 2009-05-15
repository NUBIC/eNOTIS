class RegistrationsController < ApplicationController
  layout "layouts/loggedin"

  include AuthMod
  include FaceboxRender
  before_filter :user_must_be_logged_in

  # The registration landing page
  def index 
    @accessable_protocols = Protocol.find_by_coordinator(@current_user.netid)
    RAILS_DEFAULT_LOGGER.debug(@accessable_protocols.inspect)
  end

  def show
   session[:study_id]= params[:study_id]
   @protocol = Protocol.find_by_study_id(params[:study_id])
   @protocol_local = Protocol.find_by_irb_number(params[:study_id])
   if @prootcol_locol
   	@involvements = Involvement.find(:all,:conditions=>["protocol_id = ?",@protocol_local.id])
   end
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
      @patients = Patient.find_by_mrn(params[:mrn])
      if @patients.size > 0 
	@patient =  @patients[0]
      end
    end
    respond_to do |format|
      format.html
      format.js {render_to_facebox}
    end
  end

end
