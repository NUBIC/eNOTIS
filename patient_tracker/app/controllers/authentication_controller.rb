require 'EdwServices.rb'
class AuthenticationController < ApplicationController
  include AuthMod
  include ProtocolRequests

  def index
    @netids = find_all_coordinator_netids
  end
  
  def login
    current_user = User.validate_user(params[:netid],params[:password])
  end

end
