require 'EdwServices.rb'
class AuthenticationController < ApplicationController
  include AuthMod
  include ProtocolRequests
  layout "layouts/default"

  def index
    @netids = find_all_coordinator_netids(20)
    @users = User.find(:all)
  end
  
  def login
    if authenticate_user(params[:netid],params[:password])
      flash[:notice] = "You are logged in as #{params[:netid]}" #TODO-don't do this, scrub first
      redirect_to default_path
    else
      flash[:notice] = "Unable to validate user"
      redirect_to authentication_index_path
    end
  end
  
  def logout
    logout_user   
    flash[:notice] = "You are now logged out"
    redirect_to authentication_index_path
  end
  
end
