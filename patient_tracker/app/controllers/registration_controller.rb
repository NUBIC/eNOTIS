class RegistrationController < ApplicationController
  include AuthMod
  before_filter :authenticate

  # The registration landing page
  def index 

  end

end
