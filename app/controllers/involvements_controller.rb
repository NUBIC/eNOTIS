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
  end
  
  def show 
    @involvement = Involvement.find(params[:id])
    authorize! :show, @involvement
    params[:study] = @involvement.study.irb_number
    respond_to do |format|
      format.html {render :action => :show}
      format.js {render :layout => false, :action => :show}
    end
  end

  def other
    @involvement = Involvement.find(params[:id], :include => [:study, {:subject => {:involvements => :study}}])
    @studies = (@involvement.subject.involvements - [@involvement]).map(&:study)
    return render :partial => "partials/other_studies_privacy" unless params[:accept]
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end
  
  def new
    @study = Study.find_by_irb_number(params[:study])
    @involvement = Involvement.new
    @involvement.subject = Subject.new
    @involvement.involvement_events.build(:event_type => @study.event_types.find_by_name("Consented"))
    @involvement.involvement_events.build(:event_type => @study.event_types.find_by_name("Completed"))
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end
  
  def edit
    @involvement = Involvement.find(params[:id])
    authorize! :edit, @involvement
    @study = @involvement.study
    params[:study] = @study.irb_number
    @involvement.involvement_events.build(:event_type => @study.event_types.find_by_name("Consented")) unless @involvement.consented
    @involvement.involvement_events.build(:event_type => @study.event_types.find_by_name("Completed")) unless @involvement.completed_or_withdrawn
    respond_to do |format|
      format.html {render :action => :new}
      format.js {render :layout => false, :action => :new}
    end
  end
  
  def create
    study = Study.find_by_irb_number(params[:study][:irb_number])
    authorize! :import, study
    @involvement = Involvement.new(params[:involvement].merge(:study => study))
    if @involvement.save
      flash[:notice] = "Created"
    else
      flash[:error] = "Error: #{@involvement.errors.full_messages}"
    end
    redirect_to study_path(study)
  end
  
  def update
    @involvement = Involvement.find(params[:id])
    authorize! :update, @involvement
    @involvement_events = @involvement.involvement_events
    study = Study.find_by_irb_number(params[:study][:irb_number])
    if @involvement.update_attributes(params[:involvement])
      flash[:notice] = "Updated"
    else
      flash[:error] = "Error: #{@involvement.errors.full_messages}"
    end
    redirect_to study_path(study)
  end
  
  # The delete action should remove the involvement and any child involvement events. 
  # The subject model should not be deleted.
  # This feature will leave subjects without involvements. 
  def destroy
    @involvement = Involvement.find(params[:id])
    authorize! :destroy, @involvement
    @study       = @involvement.study
    @involvement.destroy # :dependent => :destroy takes care of removing involvement events # @involvement.involvement_events.destroy_all
    respond_to do |format|
      format.html {redirect_to @study}
      format.js {render :layout => false}
    end
  end
  
  def upload
    # Subjects are created via uploads
<<<<<<< HEAD
    @study = Study.find_by_irb_number(params[:study_id]) || Study.new
    authorize! :import, @study
=======
    @study = Study.find_by_irb_number(params[:study_id]) || Study.new # <=== Why are we creating a new study object here? -BLC
>>>>>>> specs passing, features still failing
    @up = StudyUpload.create(:user => current_user, :study_id => @study.id, :upload => params[:file])
    success = @up.legit?
    redirect_to_studies_or_study(params[:study_id], success ? :notice : :error, success ? @up.summary : "Oops. Your upload had some issues.<br/>Please click <a href='#{@study.irb_number ? import_study_path(@study) : '#'}' rel='#import'>Import</a> to see the result.")
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
