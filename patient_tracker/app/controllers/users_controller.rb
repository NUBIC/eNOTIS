class UsersController < ApplicationController
  layout "layouts/main"
  include FaceboxRender
  before_filter :user_must_be_logged_in

  # The dashboard
  def dashboard
    @accessable_studies = current_user.studies 
  end
end
