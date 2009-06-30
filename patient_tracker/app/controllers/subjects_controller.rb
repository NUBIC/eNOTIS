class SubjectsController < ApplicationController
  require 'fastercsv'
  include FaceboxRender
  before_filter :user_must_be_logged_in
  layout "main"

  def index
    @study = Study.find_by_irb_number(params[:irb_number])
    @involvements = @study ? @study.involvements : []
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
    @subjects = Subject.find_by_mrn(params[:mrn])
  end
  
  def create
    @study_upload = StudyUpload.create(:study_id => params[:study], :upload => params[:file])
    temp_file = Tempfile.new("results")
    if self.class.csv_sanity_check(@study_upload.upload, temp_file)
      self.class.queue_import(@study_upload.id)
      redirect_to params[:study].blank? ? studies_path : study_path(:id => params[:study])
    else
      @study_upload.result = temp_file
      temp_file.close!
      results_file_name = @study_upload.upload_file_name.gsub(/(\.csv)?$/, '-result.csv')
      headers['Content-Disposition'] = "attachment; filename='#{results_file_name}'"
      if request.env['HTTP_USER_AGENT'] =~ /msie/i
        headers.merge!({'Pragma' => 'public', 'Content-type' => 'text/plain; charset=utf-8', 'Cache-Control' => 'no-cache, must-revalidate, post-check=0, pre-check=0', 'Expires' => '0'})
      else
        headers['Content-type'] = 'text/csv; charset=utf-8'        
      end
      render :text => @study_upload.result.to_io.read
    end
  end

  def self.queue_import(id)
    
  end
  
  def self.csv_sanity_check(csv, temp_file = Tempfile.new("results")) # csv can be a string, file, or Paperclip::Attachment
    # We may possibly want to sanity check dates with Chronic http://chronic.rubyforge.org/
    csv = csv.to_io if csv.class == Paperclip::Attachment
    errors = []
    FasterCSV.open(temp_file.path, "r+") do |temp_stream|
      FasterCSV.parse(csv, :headers => :first_row, :return_headers => true, :header_converters => :symbol) do |r|      
        errors << (r[:mrn].blank? ? (r[:last_name].blank? or r[:first_name].blank? or r[:dob].blank?) ? "A first_name and last_name and dob, or an mrn is required. " : "" : "") + \
          ((r[:subject_event_type].blank? or r[:subject_event_date].blank?) ? "A subject event type and date is required." : "")
        temp_stream << (errors.size == 1 ? ["import_errors"] : [errors.last]) + r.fields
      end
    end
    errors.uniq == [""]
  end
end
