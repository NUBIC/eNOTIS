require 'fastercsv'
# require 'activemessaging/processor'

class SubjectsController < ApplicationController
  layout "layouts/main"  

  # Includes
  # include ActiveMessaging::MessageSender
  # include Chronic

  # Authentication
  before_filter :user_must_be_logged_in

  # Auditing
  has_view_trail :except => :index

  # Messaging
  # publishes_to :patient_upload

  # Public instance methods (actions)
  def merge
    # syncs a local record to a selected medical record
    @local = Subject.find(params[:local_id])
    @study = @local.studies.first
    Subject.find(:first, :conditions=> {:mrn=>params[:mrn]}, :span => :global, :service_opts => {:netid => current_user.netid}).merge!(@local)
    flash[:notice] = "Subject Synced"
    redirect_to study_path(@study)
  end
  
  def create
    # Subjects are created via uploads
    @study = Study.find_by_irb_number(params[:study_id]) || Study.new
    @up = StudyUpload.create(:user => current_user, :study_id => @study.id, :upload => params[:file])
    success = @up.legit?
    redirect_to_studies_or_study(params[:study_id], success ? :notice : :error, @up.summary)
  end
  
  def search
    #this method is designed specifically to search for a locally stored subject in the edw
    @local = Subject.find(params[:subject])
    @subjects = Subject.find(:all,:conditions=>{:first_name =>@local.first_name,:last_name =>@local.last_name,:birth_date => @local.birth_date},:span=>:foreign,:service_opts=>{:netid=>current_user.netid})
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end
  
  # Private instance methods
  private
  
  def redirect_to_studies_or_study(study_id, flash_type = nil, flash_message = nil)
    flash[flash_type] = flash_message if !flash_type.blank? && !flash_message.blank?
    redirect_to study_id.blank? ? studies_path : study_path(study_id)
  end
end