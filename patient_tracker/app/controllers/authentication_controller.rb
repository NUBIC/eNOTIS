require 'EdwServices.rb'
class AuthenticationController < ApplicationController
  include AuthMod
  include ProtocolRequests

  def index
    @netids = find_all_coordinator_netids
  end
  
  def login
    current_user = User.validate_user(params[:netid],params[:password])
    if current_user
      redirect_to default_path
    else
      flash[:notice] = "Unable to validate user"
      redirect_to authentication_index_path
    end
  end

end
