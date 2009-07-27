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
    if InvolvementEvent.add_via_ui(params.merge({:study => {:irb_number => session[:study_irb_number]}}))
      redirect_to studies_path(session[:study_irb_number])
      flash[:notice] = "Created"
    else
      respond_with_error
    end
  rescue
    respond_with_error
  end
  
  protected
  
  def respond_with_error
    respond_to do |format|
      format.html{ render(:layout => false, :text => "Error")}
      # format.js{ render(:update){|page| page << "jQuery.facebox('Error')" }}
    end
  end
  
end
