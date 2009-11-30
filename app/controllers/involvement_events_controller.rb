class InvolvementEventsController < ApplicationController
  layout "layouts/main"
  
  # Includes
  include Chronic
  
  # Authentication
  before_filter :user_must_be_logged_in
  
  # Auditing
  has_view_trail :except => :index
  
  # Public instance methods (actions)
  def index
    @events = current_user.involvement_events
  end

  def new
    @subject = Subject.find(params[:subject]) unless params[:subject].nil?
    # Get @events, @races, @genders, @ethnicities instance variables from dictionary
    ["event", "race", "gender", "ethnicity"].each{|category| self.instance_variable_set("@#{category.pluralize}", DictionaryTerm.lookup_category_terms(category))}
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    params[:user] = current_user.attributes.symbolize_keys
    if InvolvementEvent.add(params)
      flash[:notice] = params[:subject].has_key?(:id) ? "Added" : "Created"
      redirect_to study_path(params[:study][:irb_number], :anchor => "subjects")
    else
      flash[:error] = "Error"
      redirect_to study_path(params[:study][:irb_number], :anchor => "subjects")
    end
  end
  
  def show
    @involvement_event = InvolvementEvent.find(params[:id])
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end
  
  def destroy
    @involvement_event = InvolvementEvent.find(params[:id])
    destination = study_path(@involvement_event.involvement.study, :anchor => "events")
    @involvement_event.destroy
    redirect_to destination
  end

end
