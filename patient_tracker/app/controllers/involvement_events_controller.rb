class InvolvementEventsController < ApplicationController
  layout "layouts/main"
  include FaceboxRender
  before_filter :user_must_be_logged_in
  has_view_trail :except => :index
  
  def index
    # TODO Refactor this to a method on user -blc
    @events = current_user.studies.map(&:involvements).flatten.map(&:involvement_events).flatten
  end

  def new
    @subject = Subject.find(params[:subject_id]) unless params[:subject_id].nil?
    respond_to do |format|
      format.html
      format.js {render_to_facebox}
    end
  end

  def create
    # TODO Refactor into smaller several smaller methods
      @study = Study.find(:first,:conditions=>["irb_number='#{session[:study_irb_number]}'"],:span=>:global)
      if !params[:subject_id]
        @subject = find_or_create_subject(params)
        @involvement = @study.add_subject(@subject) unless @subject.nil?
      else
        @subject= Subject.find(params[:subject_id])
        @involvement = Involvement.find_by_subject_id_and_study_id(@subject.id,@study.id)  
      end
      event = @involvement.involvement_events.create(:event_type=>params[:event_type],:event_date=>params[:event_date],:description=>params[:description])
    
    if event 
      respond_to do |format|
        format.html do
          flash[:notice] = "Success"
          redirect_to study_path(@study)
        end
        format.js do
          render_to_facebox :html => "success"
        end
      end
    else
      respond_to do |format|
        format.html do
          flash[:notice] = "Fail" # TODO Make this message a little clearer
          redirect_to @study ? study_path(@study) : studies_path
        end
        format.js do
          render_to_facebox :html => "#{@subject.inspect}: #{@study.inspect}: #{@involvement.inspect}"
        end
      end
    end
  end

  
 def find_or_create_subject(params)
    if !params[:mrn].blank?
      @subject = Subject.find(:first,:conditions=>["mrn='#{params[:mrn]}'"],:span=>:global)
    elsif !params[:first_name].blank? and !params[:last_name].blank? and !params[:birth_date].blank?
      @subject = Subject.create(:first_name=>params[:first_name],:last_name=>params[:last_name],:birth_date=>params[:birth_date])
    else
      @subject = nil
    end
    return @subject
 end


  def search
    if !params[:mrn].blank?
      subject = Subject.find(:first,:conditions=>["mrn='#{params[:mrn]}'"],:span=>:global)
      @subjects = [subject] || []
    elsif !params[:first_name].blank? and !params[:last_name].blank? and !params[:birth_date].blank?
      @subjects = Subject.find(:all,:conditions=> ["first_name = #{params[:first_name]} and last_name = #{params[:last_name]} and birth_date =#{params[:birth_date]}"],:span=>:foreign)
      if @subjects.empty?
        @subjects = [Subject.new(:first_name=>params[:first_name],:last_name=>params[:last_name],:birth_date=>params[:birth_date])]
      end
    end
    respond_to do |format|
      format.html
      format.js {render_to_facebox}
    end
  end

end
