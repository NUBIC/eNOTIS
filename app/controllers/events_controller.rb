class EventsController < ApplicationController

  layout 'main'
  # Authorization
  include Bcsec::Rails::SecuredController
  permit :user

  # Auditing
  has_view_trail 

  # Public instance methods (actions)

  def index
    @involvement = Involvement.find(params[:involvement_id])
    @study = @involvement.study
    @events = @involvement.involvement_events
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def new
    @involvement = Involvement.find(params[:involvement_id])
    @study = @involvement.study
    @involvement_event = @involvement.involvement_events.new
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def edit
    @involvement_event = InvolvementEvent.find(params[:id])
    @involvement = @involvement_event.involvement
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def update
    @involvement = Involvement.find(params[:involvement_id])
    @involvement_event = InvolvementEvent.find(params[:id])
    @involvement_event.update_attributes(params[:involvement_event])
    redirect_to @involvement
  end


  def create
    @involvement = Involvement.find(params[:involvement_id])
    @involvement.involvement_events.create(params[:involvement_event])
    redirect_to @involvement
  end

  def destroy
    @involvement_event = InvolvementEvent.find(params[:id])
    @involvement_event.destroy
    redirect_to @involvement_event.involvement
  end
end
