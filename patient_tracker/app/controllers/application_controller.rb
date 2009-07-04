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
  
  
end
