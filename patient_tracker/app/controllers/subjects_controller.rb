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
    if (check_csv = self.check_csv(params[:file])) == true
      if params[:study]
        redirect_to study_path(:id => params[:study])
      else
        render :layout => false, :text => ""
      end
    else
      filename = "foo.csv"
      headers["Content-Disposition"] = "attachment; filename='#{filename}'"
      # if request.env['HTTP_USER_AGENT'] =~ /msie/i
      #   headers.merge({'Pragma' => 'public', "Content-type" => "text/plain", 'Cache-Control' => 'no-cache, must-revalidate, post-check=0, pre-check=0', 'Expires' => "0"})
      # else
        headers["Content-Type"] ||= 'text/csv'        
      # end
      send_data(params[:file].to_s, :type => 'text/csv; charset=utf-8; header=present')
    end
  end
  
  def self.check_csv(file)
    attrs = %w(mrn last_name first_name dob subject_event_type subject_event_date).map(&:to_sym)
    errors = []
    FasterCSV.foreach(file.path, :headers => :first_row, :return_headers => false, :header_converters => :symbol) do |r|      
      errors << (r[:mrn].blank? ? (r[:last_name].blank? or r[:first_name].blank? or r[:dob].blank?) ? "A first_name and last_name and dob, or an mrn is required. " : "" : "") + \
        ((r[:subject_event_type].blank? or r[:subject_event_date].blank?) ? "A subject event type and date is required." : "")
    end
    errors.uniq == [""] ? true : errors
  end
end
