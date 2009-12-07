class UsersController < ApplicationController 
  layout "layouts/main"
  
  # Authentication
  before_filter :user_must_be_logged_in

  # Public instance methods (actions)
  # def dashboard
  #   @studies = current_user.studies
  #   @involvement_events = current_user.involvement_events
  # end

end
