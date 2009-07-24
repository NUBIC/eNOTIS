require 'fastercsv'
require 'activemessaging/processor'

class SubjectsController < ApplicationController
  layout "layouts/main"  

  # Includes
  include ActiveMessaging::MessageSender
  include FaceboxRender
  include Chronic

  # Authentication
  before_filter :user_must_be_logged_in

  # Auditing
  publishes_to :patient_upload
  has_view_trail :except => :index

  # Public instance methods (actions)
  def index
    if params[:irb_number]
      @study = Study.find_by_irb_number(params[:irb_number])
      @involvements = @study.involvements || []
    else
      # TODO Clean up... create coordinator intstance methond
      @involvements = (@study ? @study.involvements : current_user.coordinators.map(&:study).flatten.map(&:involvements).flatten) || []
    end
  end

  def show
    @subject = Subject.find(params[:id])
    @involvements = @subject.involvements#Involvement.find_all_by_subject_id(@subject.id)
    respond_to do |format|
      format.html
      format.js {render_to_facebox}
    end
  end

  def search
    #this method is designed specifically to search for a locally stored subject in the edw
    @local = Subject.find(params[:id])
    @subjects = Subject.find(:all,:conditions=> ["first_name = #{@local.first_name} and last_name = #{@local.last_name} and birth_date =#{@local.birth_date}"],:span=>:foreign)
    respond_to do |format|
      format.html
      format.js {render_to_facebox}
    end
  end

  def sync
    # this action syncs a local records to a selected medical record
    @local = Subject.find(params[:local_id])
    @local.sync!(Subject.find(:first,:conditions=>["mrn='#{params[:mrn]}'"], :span=>:global).attributes)
    respond_to do |format|
      format.html do
        flash[:notice] = "Success"
        redirect_to study_path(@study)
      end
        format.js do
        render_to_facebox :html => "Subject Synced to Medical Record"
      end
    end
  end
  
  def create
    # Subjects created via uploads
    @study = Study.find_by_irb_number(params[:study_id]) # Study.find(:first,:conditions=>["irb_number='#{params[:study_id]}'"],:span=>:global)
    @study_upload = StudyUpload.new(:user_id=>current_user.id,:study_id => @study.id, :upload => params[:file])
    temp_file = Tempfile.new("results")
    if csv_sanity_check(@study_upload.upload, temp_file)
      @study_upload.save
      publish :patient_upload, @study_upload.id.to_s
      redirect_to params[:study_id].blank? ? studies_path : study_path(:id => params[:study_id])
    else
      @study_upload.result = temp_file
      temp_file.close!
      results_file_name = @study_upload.upload_file_name.gsub(/(\.csv)?$/, '-result.csv')
      headers['Content-Disposition'] = "attachment; filename='#{results_file_name}'"

      # Internet explorer requires special headers in order for a csv file to be downloaded instead of displayed
      if request.env['HTTP_USER_AGENT'] =~ /msie/i
        headers.merge!({'Pragma' => 'public', 'Content-type' => 'text/plain; charset=utf-8', 'Cache-Control' => 'no-cache, must-revalidate, post-check=0, pre-check=0', 'Expires' => '0'})
      else
        headers['Content-type'] = 'text/csv; charset=utf-8'        
      end
      render :text => @study_upload.result.to_io.read
    end
  end

  def csv_sanity_check(csv, temp_file = Tempfile.new("results")) # csv can be a string, file, or Paperclip::Attachment
    # We may possibly want to sanity check dates with Chronic http://chronic.rubyforge.org/
    csv = csv.to_io if csv.class == Paperclip::Attachment
    @validity = true
    FasterCSV.open(temp_file.path, "r+") do |temp_stream|
      FasterCSV.parse(csv, :headers => :first_row, :return_headers => false, :header_converters => :symbol) do |r|
        errors = validate_subject_params(r)
        temp_stream << r.fields + [errors.join(". ")] unless errors.empty?
        @validity = false if !errors.empty?
      end
    end
    return @validity
  end
 
 end
