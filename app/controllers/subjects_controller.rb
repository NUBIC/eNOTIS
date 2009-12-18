require 'fastercsv'
require 'activemessaging/processor'

class SubjectsController < ApplicationController
  layout "layouts/main"  

  # Includes
  include ActiveMessaging::MessageSender
  include Chronic

  # Authentication
  before_filter :user_must_be_logged_in

  # Auditing
  has_view_trail :except => :index

  # Messaging
  publishes_to :patient_upload

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
    @study_upload = StudyUpload.new(:user_id => current_user.id, :study_id => params[:study_id], :upload => params[:file])
    return redirect_to_studies_or_study(params[:study_id], :error, "Please provide a file to upload.") unless @study_upload.upload.valid?
    
    temp_file = Tempfile.new("results")
    if csv_sanity_check(@study_upload.upload, temp_file)
      @study_upload.save
      temp_file.close!
      publish :patient_upload, @study_upload.id.to_s
      redirect_to_studies_or_study params[:study_id]
    else
      @study_upload.result = temp_file
      temp_file.close!
      setup_csv(request, headers, @study_upload.upload_file_name.gsub(/(\.csv)?$/, '-result.csv'))
      render :text => @study_upload.result.to_io.read
    end
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
  def setup_csv(r, h, filename)
    h['Content-Disposition'] = "attachment; filename=#{filename}"
    # Internet explorer requires special headers in order for a csv file to be downloaded instead of displayed
    if r.env['HTTP_USER_AGENT'] =~ /msie/i
      h.merge!({'Pragma' => 'public', 'Content-type' => 'text/plain; charset=utf-8', 'Cache-Control' => 'no-cache, must-revalidate, post-check=0, pre-check=0', 'Expires' => '0'})
    else
      h.merge!({'Content-type' => 'text/csv; charset=utf-8'})
    end    
  end
  def csv_sanity_check(csv, temp_file = Tempfile.new("results")) # csv can be a string, file, or Paperclip::Attachment
    # We may possibly want to sanity check dates with Chronic http://chronic.rubyforge.org/
    csv = csv.to_io if csv.class == Paperclip::Attachment
    csv_is_valid = true
    FasterCSV.open(temp_file.path, "r+") do |temp_stream|
      FasterCSV.parse(csv, :headers => :first_row, :return_headers => false, :header_converters => :symbol) do |r|
        r[:irb_number] = params[:study_id]
        errors = InvolvementEvent.sanity_check(r)
        temp_stream << r.fields + [errors.join(". ")] unless errors.empty?
        csv_is_valid = false if !errors.empty?
      end
    end
    return csv_is_valid
  end
 end

