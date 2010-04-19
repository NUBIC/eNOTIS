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
    @involvement.subject = Subject.new
    @involvement.involvement_events.build(:event => "Consented")
    @involvement.involvement_events.build(:event => "Completed")
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end
  
  def edit
    @involvement = Involvement.find(params[:id])
    params[:study] = @involvement.study.irb_number
    @involvement.involvement_events.build(:event => "Consented") unless @involvement.consented
    @involvement.involvement_events.build(:event => "Completed") unless @involvement.completed
    respond_to do |format|
      format.html {render :action => :new}
      format.js {render :layout => false, :action => :new}
    end
  end
  
  def create
    study = Study.find_by_irb_number(params[:study][:irb_number])
    @involvement = Involvement.new(params[:involvement].merge(:study => study))
    if @involvement.save
      flash[:notice] = "Created"
    else
      flash[:error] = "Error"
    end
    redirect_to study_path(study)
  end
  
  def update
    @involvement = Involvement.find(params[:id])
    @involvement_events = @involvement.involvement_events
    study = Study.find_by_irb_number(params[:study][:irb_number])
    if @involvement.update_attributes(params[:involvement])
      flash[:notice] = "Created"
    else
      flash[:error] = "Error #{@involvement.errors.full_messages }"
    end
    redirect_to study_path(study)
  end
  
  def destroy
    # @involvement_event = InvolvementEvent.find(params[:id])
    # destination = study_path(@involvement_event.involvement.study)
    # @involvement_event.destroy
    # redirect_to destination
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
  
  def sample
    # IE headers
    headers.merge!({'Pragma' => 'public', 'Cache-Control' => 'no-cache, must-revalidate, post-check=0, pre-check=0', 'Expires' => '0'}) if request.env['HTTP_USER_AGENT'] =~ /msie/i
    # download, don't view in browser
    send_data StudyUpload.required_columns.join(","), :filename => 'sample.csv', :content_type => 'text/csv'
  end
  
  # Private instance methods
  private
  
  def redirect_to_studies_or_study(study_id, flash_type = nil, flash_message = nil)
    flash[flash_type] = flash_message if !flash_type.blank? && !flash_message.blank?
    redirect_to study_id.blank? ? studies_path : study_path(study_id)
  end
end
