require 'EdwServices.rb'
class AuthenticationController < ApplicationController
  include AuthMod
  include ProtocolRequests

  def index
    @netids = find_all_coordinator_netids
    @users = User.find(:all)
  end
  
  def login
    if authenticate_user(params[:netid],params[:password])
      flash[:notice] = "You are logged in"
      redirect_to default_path
    else
      flash[:notice] = "Unable to validate user"
      redirect_to authentication_index_path
    end
  end

end
