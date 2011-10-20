class EventTypesController < ApplicationController

  layout 'main'
  # Authorization
  include Bcsec::Rails::SecuredController
  permit :user

  # Auditing
  has_view_trail 

  # Public instance methods (actions)

  def index
    @study = Study.find_by_irb_number(params[:study_id])
    @uneditable_events, @editable_events = @study.event_types.partition{|ev| ev.editable == false }
    respond_to do |format|
      format.js {render :layout => false}
    end
  end

  def new
    @study = Study.find_by_irb_number(params[:study_id])
    @event_type = @study.event_types.new
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def edit
    @event_type = EventType.find(params[:id])
    @study = @event_type.study
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def update
    @event_type = EventType.find(params[:id])
    @study = @event_type.study
    @event_type.update_attributes(params[:event_type]) 
    if @event_type.save
      flash[:notice] = "Successfully updated event_type."
    else
      flash[:error] = "<ul>"+@event_type.errors.map {|e| "<li>" + e.first.titleize + "</li>"}.join + "</ul>"
    end
    @uneditable_events, @editable_events = @study.event_types.partition{|ev| ev.editable == false }
    respond_to do |format|
      format.html {redirect_to @study}
      format.js {render :index, :layout => false}
    end
  end


  def create
    @study = Study.find_by_irb_number(params[:study_id])
    @event_type = @study.event_types.create(params[:event_type])
    @uneditable_events, @editable_events = @study.event_types.partition{|ev| ev.editable == false }
    if @event_type.save
      flash[:notice] = "Successfully created event_type."
    else
      flash[:error] = "<ul>"+@event_type.errors.map {|e| "<li>" + e.first.titleize + "</li>"}.join + "</ul>"
    end
    respond_to do |format|
      format.html {redirect_to @study}
      format.js {render :index, :layout => false}
    end
  end

  def destroy
    @event_type = EventType.find(params[:id])
    @study = @event_type.study
    if @event_type.destroy
      flash[:notice] = "Successfully deleted event_type."
    else
      flash[:error] = "<ul>"+@event_type.errors.map {|e| "<li>" + e.first.titleize + "</li>"}.join + "</ul>"
    end
    @uneditable_events, @editable_events = @study.event_types.partition{|ev| ev.editable == false }
    respond_to do |format|
      format.html {redirect_to @study}
      format.js {render :index, :layout => false}
    end
  end
end
