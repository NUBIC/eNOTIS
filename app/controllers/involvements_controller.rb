class InvolvementsController < ApplicationController
  layout "layouts/main"
  
  # Includes
  include Chronic
  
  # Authentication
  before_filter :user_must_be_logged_in
  
  # Auditing
  has_view_trail :except => :index
  
  # Public instance methods (actions)
  def index
    # @subject = Subject.find(params[:id])
    # return render :action => "confidential" unless params[:accept]
  end

  def new
    @involvement = Involvement.new
    @subject = Subject.new
    @consented = InvolvementEvent.new(:event_type_id => DictionaryTerm.event_id("consented"))
    @completed = InvolvementEvent.new
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end
  
  def edit
    @involvement = Involvement.find(params[:id])
    @subject = @involvement.subject
    @consented = @involvement.consented
    @completed = @involvement.completed
  end
  
  def create
    # return render :text => params.inspect
    params[:user] = current_user.attributes.symbolize_keys
    if InvolvementEvent.add(params)
      flash[:notice] = params[:subject].has_key?(:id) ? "Added" : "Created"
    else
      flash[:error] = "Error"
    end
    redirect_to study_path(params[:study][:irb_number])
  end
  
  def update
    # @subject = Subject.find(params[:subject][:id])
    # @study = Study.find_by_irb_number(params[:study][:irb_number])
  end
  
  def destroy
    # @subject = Subject.find(params[:subject][:id])
    # @study = Study.find_by_irb_number(params[:study][:irb_number])    
  end
  
  def upload
    # Subjects are created via uploads
    @study = Study.find_by_irb_number(params[:study_id]) || Study.new
    @up = StudyUpload.create(:user => current_user, :study_id => @study.id, :upload => params[:file])
    success = @up.legit?
    redirect_to_studies_or_study(params[:study_id], success ? :notice : :error, @up.summary)
  end
  
  def merge
    # # syncs a local record to a selected medical record
    # @local = Subject.find(params[:local_id])
    # @study = @local.studies.first
    # Subject.find(:first, :conditions=> {:mrn=>params[:mrn]}, :span => :global, :service_opts => {:netid => current_user.netid}).merge!(@local)
    # flash[:notice] = "Subject Synced"
    # redirect_to study_path(@study)
  end
  
  # Private instance methods
  private
  
  def redirect_to_studies_or_study(study_id, flash_type = nil, flash_message = nil)
    flash[flash_type] = flash_message if !flash_type.blank? && !flash_message.blank?
    redirect_to study_id.blank? ? studies_path : study_path(study_id)
  end
end
