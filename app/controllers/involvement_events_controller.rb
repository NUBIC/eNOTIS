class InvolvementEventsController < ApplicationController
  layout "layouts/main"
  
  # Includes
  # include FaceboxRender
  include Chronic
  
  # Authentication
  before_filter :user_must_be_logged_in
  
  # Auditing
  has_view_trail :except => :index
  
  # Public instance methods (actions)
  def index
    # TODO Refactor this to a method on user -blc
    @events = current_user.studies.map(&:involvements).flatten.map(&:involvement_events).flatten
  end

  def new
    @subject = Subject.find(params[:subject_id]) unless params[:subject_id].nil?
    # Get @events, @races, @genders, @ethnicities instance variables from dictionary
    ["event", "race", "gender", "ethnicity"].each{|category| self.instance_variable_set("@#{category.pluralize}", DictionaryTerm.find_all_by_category(category.capitalize))}
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    if InvolvementEvent.add(params)
      flash[:notice] = "Created"
      redirect_to study_path(params[:study][:irb_number], :anchor => "subjects")
    else
      flash[:error] = "Error"
      redirect_to study_path(params[:study][:irb_number], :anchor => "subjects")
    end
  end

end
