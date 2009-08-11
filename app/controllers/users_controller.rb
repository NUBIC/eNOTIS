class UsersController < ApplicationController 
  layout "layouts/main"

  # Includes
  # include FaceboxRender
  
  # Authentication
  before_filter :user_must_be_logged_in

  # Public instance methods (actions)
  def dashboard
    # raise "testing exception notifier - yoon" # http://weblog.jamisbuck.org/2007/3/7/raising-the-right-exception
    @studies = current_user.studies
    @top_involvement_events = current_user.involvement_events[0,5]
    @more_events = @current_user.involvement_events.size - 5
  end

end
