class PatientsController < ApplicationController
  include AuthMod
  include FaceboxRender
  before_filter :user_must_be_logged_in
  layout "layouts/loggedin"

  def index
    
    @protocol = Protocol.find_by_irb_number(params[:irb_number])
    @involvements = @protocol.involvements
  end

  def show
    @patient = Patient.find(params[:id])
    @involvements = @patient.involvements#Involvement.find_all_by_patient_id(@patient.id)
    respond_to do |format|
      format.html
      format.js {render_to_facebox}
    end
  end

  def search
    @patients = Patient.find_by_mrn(params[:mrn])
  end
  
  def create
    render :layout => false, :text => ""
  end
end
