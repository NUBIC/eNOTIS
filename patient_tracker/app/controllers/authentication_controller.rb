class AuthenticationController < ApplicationController

  def login
    User.validate_user(params[:netid],params[:password])
  end

end
