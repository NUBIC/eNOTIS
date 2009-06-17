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
    if self.check_csv params[:file]
      if params[:study]
        redirect_to study_path(:id => params[:study])
      else
        render :layout => false, :text => ""
      end
    else
      filename = "foo.csv"
      headers["Content-Disposition"] = "attachment; filename='#{filename}'"
      if request.env['HTTP_USER_AGENT'] =~ /msie/i
        headers.merge({'Pragma' => 'public', "Content-type" => "text/plain", 'Cache-Control' => 'no-cache, must-revalidate, post-check=0, pre-check=0', 'Expires' => "0"})
      else
        headers["Content-Type"] ||= 'text/csv'        
      end
      send_data(params[:file].to_s, :type => 'text/csv; charset=utf-8; header=present')
    end
  end
  
  def self.check_csv(file)
    arr_of_arrs = FasterCSV.read(file.path, :headers => :first_row, :return_headers => false, :header_converters => :symbol)
    bool_arr = arr_of_arrs.map do |row|
      !row[:mrn].blank? or (!row[:last_name].blank? and !row[:first_name].blank? and !row[:dob].blank?)
    end
    bool_arr.uniq == [true]
    
    # running_total = 0
    #     FasterCSV.filter( :headers           => true,
    #                        :return_headers    => true,
    #                        :header_converters => :symbol,
    #                        :converters        => :numeric ) do |row|
    #        if row.header_row?
    #          row << "Running Total"
    #        else
    #          row << (running_total += row[:quantity] * row[:price])
    #        end
    #     end
    
  end
end
