class UsersController < ApplicationController 
  layout "layouts/main"

  # Includes
  include FaceboxRender
  
  # Authentication
  before_filter :user_must_be_logged_in

  # Public instance methods (actions)
  def dashboard
    @studies = current_user.studies 
  end

end
