# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  include ControllerAuthentication

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # TODO Turn this back on -blc
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  APP_VERSION = "0.0.1a"
  
  SYSTEM_STATUSES = { :up => "Don't think twice, it's alright",
                      :down => "Blowin' in the wind (down, we're working on it)",
                      :scheduled_maintenance => "The times they are a-changin' (down for scheduled maintenance)",
                      :scheduled_restored => "Like a rolling stone (scheduled maintenance complete)" }
  
  def system_status
    %w(up down scheduled_maintenance scheduled_restored).rand
  end
end
