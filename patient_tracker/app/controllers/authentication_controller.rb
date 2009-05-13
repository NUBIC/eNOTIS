class AuthenticationController < ApplicationController
  include AuthMod

  def index
  end
  
  def login
    current_user = User.validate_user(params[:netid],params[:password])
  end

end
