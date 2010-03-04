class InvolvementEventsController < ApplicationController
  layout "layouts/main"
  
  # Includes
  include Chronic
  
  # Authentication
  before_filter :user_must_be_logged_in
  
  # Auditing
  has_view_trail :except => :index
  
  def show
    @involvement_event = InvolvementEvent.find(params[:id])
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end
  
  def destroy
    @involvement_event = InvolvementEvent.find(params[:id])
    destination = study_path(@involvement_event.involvement.study)
    @involvement_event.destroy
    redirect_to destination
  end

end
