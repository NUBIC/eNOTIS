class InvolvementEventsController < ApplicationController
  layout "layouts/main"
  include FaceboxRender
  include Chronic
  before_filter :user_must_be_logged_in
  has_view_trail :except => :index
  
  def index
    # TODO Refactor this to a method on user -blc
    @events = current_user.studies.map(&:involvements).flatten.map(&:involvement_events).flatten
  end

  def new
    #get necessary subject, race and gender and ethicity information from dictionary
    @subject = Subject.find(params[:subject_id]) unless params[:subject_id].nil?
    @events = DictionaryTerm.find_all_by_category("Event")
    @races = DictionaryTerm.find_all_by_category("Race")
    @genders = DictionaryTerm.find_all_by_category("Gender")
    @ethnicities = DictionaryTerm.find_all_by_category("Ethnicity")
    respond_to do |format|
      format.html
      format.js {render_to_facebox}
    end
  end

  def create
      #too much controller logic. Needs to be moved to a model
      @errors=[]
      @study = Study.find(:first,:conditions=>["irb_number='#{session[:study_irb_number]}'"],:span=>:global)
      if params[:subject_id].nil?
        @errors = validate_subject_params(params)
        if @errors.empty?
          @subject = find_or_create_subject(params)
          @subject.save unless @subject.nil?
          @involvement = @study.add_subject(@subject,params) unless @subject.nil?
          @involvement.involvement_events.create(:event_type_id=>params[:event_type],:occured_at=>params[:event_date],:note=>params[:note])
        end
      else
        @subject= Subject.find(params[:subject_id])
        @involvement = @study.add_subject(@subject,params)
        @involvement.involvement_events.create(:event_type_id=>params[:event_type],:occured_at=>Chronic.parse(params[:event_date]),:note=>params[:note])
      end
      respond_to do |format|
        format.html
        format.js {render_to_facebox}
      end
  end

 def find_or_create_subject(params)
    if !params[:mrn].blank?
      @subject = Subject.find(:first,:conditions=>["mrn='#{params[:mrn]}'"],:span=>:global)
    end
    if !params[:first_name].blank? and !params[:last_name].blank? and !params[:birth_date].blank? and @subject.nil?
      @subject = Subject.create(:first_name=>params[:first_name],:last_name=>params[:last_name],:birth_date=>Chronic.parse(params[:birth_date]))
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
