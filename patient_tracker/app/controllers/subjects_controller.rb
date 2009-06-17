class SubjectsController < ApplicationController
  require 'fastercsv'
  include AuthMod
  include FaceboxRender
  before_filter :user_must_be_logged_in
  layout "layouts/loggedin"

  def index
    @protocol = Study.find_by_irb_number(params[:irb_number])
    @involvements = @protocol.involvements
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
    passed = self.class.csv_sanity_check(params[:file])
    
    if passed == true
      self.class.queue_import(params[:file])
      redirect_to params[:study].blank? ? studies_path : study_path(:id => params[:study])
    else
      filename = "results.csv"
      headers['Content-Disposition'] = "attachment; filename='#{filename}'"
      if request.env['HTTP_USER_AGENT'] =~ /msie/i
        headers.merge!({'Pragma' => 'public', 'Content-type' => 'text/plain; charset=utf-8', 'Cache-Control' => 'no-cache, must-revalidate, post-check=0, pre-check=0', 'Expires' => '0'})
      else
        headers['Content-Type'] ||= 'text/csv; charset=utf-8'        
      end
      render :text => params[:file].to_s
    end
  end

  def self.queue_import(file)
    
  end
  
  def self.csv_sanity_check(file)
    # We may possibly want to sanity check dates with Chronic http://chronic.rubyforge.org/
    
    attrs = %w(mrn last_name first_name dob subject_event_type subject_event_date).map(&:to_sym)
    errors = []
    FasterCSV.foreach(file.path, :headers => :first_row, :return_headers => false, :header_converters => :symbol) do |r|      
      errors << (r[:mrn].blank? ? (r[:last_name].blank? or r[:first_name].blank? or r[:dob].blank?) ? "A first_name and last_name and dob, or an mrn is required. " : "" : "") + \
        ((r[:subject_event_type].blank? or r[:subject_event_date].blank?) ? "A subject event type and date is required." : "")
    end
    errors.uniq == [""] ? true : errors
  end
end
