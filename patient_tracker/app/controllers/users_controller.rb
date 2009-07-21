class UsersController < ApplicationController 
  layout "layouts/main"

  # Includes
  include FaceboxRender
  
  # Filters
  before_filter :user_must_be_logged_in

  # ===================== Public Actions ======================  
  
  def dashboard
    @studies = current_user.studies 
  end

end
