class RegistrationsController < ApplicationController
  layout "layouts/loggedin"

  include AuthMod
  before_filter :user_must_be_logged_in

  # The registration landing page
  def index 
    @accessable_protocols = Protocol.find_by_coordinator(@current_user.netid)
    RAILS_DEFAULT_LOGGER.debug(@accessable_protocols.inspect)
  end

end
