class EventsController < ApplicationController

  layout 'main'
  # Authorization
  #include Bcsec::Rails::SecuredController
  #permit :user
  before_filter :require_user

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
    authorize! :edit, @involvement
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def update
    @involvement = Involvement.find(params[:involvement_id])
    @involvement_event = InvolvementEvent.find(params[:id])
    authorize! :update, @involvement
    saved = @involvement_event.update_attributes(params[:involvement_event])
    if saved
      flash[:notice] = "Event Updated"
    else
      flash[:error] = "Error: #{@involvement_event.errors.full_messages}"
    end
    respond_to do |format|
      format.html {redirect_to @involvement}
      format.js {render (saved ? :index : :edit),:layout => false}
    end
  end


  def create
    @involvement = Involvement.find(params[:involvement_id])
    authorize! :update, @involvement
    @involvement_event = @involvement.involvement_events.create(params[:involvement_event])
    if @involvement_event.save
      flash[:notice] = "Event Created"
    else
      flash[:error] = "Error: #{@involvement_event.errors.full_messages}"
    end
    respond_to do |format|
      format.html {redirect_to @involvement}
      format.js {render (@involvement_event.save ? :index : :new),:layout => false}
    end
  end

  def destroy
    @involvement_event = InvolvementEvent.find(params[:id])
    authorize! :destroy, @involvement_event.involvement
    @involvement_event.destroy
    @involvement= Involvement.find(params[:involvement_id])
    flash[:notice] = "Event Deleted"
    respond_to do |format|
      format.html {redirect_to study_path(@involvement.study)}
      format.js {render :index, :layout => false}
    end
  end
end
