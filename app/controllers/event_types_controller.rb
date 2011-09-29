class EventTypesController < ApplicationController

  layout 'main'
  # Authorization
  include Bcsec::Rails::SecuredController
  permit :user

  # Auditing
  has_view_trail 

  # Public instance methods (actions)

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
    redirect_to @involvement
  end


  def create
    @study = Study.find_by_irb_number(params[:study_id])
    @study.event_types.create(params[:event_type])
    redirect_to @involvement
  end

  def destroy
    @event_type = EventType.find(params[:id])
    @study = @event_type.study
    if @event_type.destroy
      flash[:notice] = "Successfully deleted event_type."
    else
      flash[:error] = "<ul>"+@event_type.errors.map {|e| "<li>" + e.first.titleize + "</li>"}.join + "</ul>"
    end
    redirect_to edit_study_path(@study)
  end
end
