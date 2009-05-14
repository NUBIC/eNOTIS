class RegistrationController < ApplicationController
  include AuthMod
  before_filter :user_must_be_logged_in

  # The registration landing page
  def index 

  end

end
