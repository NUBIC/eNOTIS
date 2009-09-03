# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  # Helpers
  # helper :all # include all helpers, all the time
  
  # Security
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password # Scrub sensitive parameters from your log
  filter_parameter_logging :"rack.request.form_vars"
  # Authentication used for all but one (Authentication) controller, enables before_filter :user_must_be_logged_in
  include ControllerAuthentication
  
  # Exception Notifier
  include ExceptionNotifiable
  ExceptionNotifier.exception_recipients = %w(eNOTISsupport@northwestern.edu)
  ExceptionNotifier.sender_address = %("eNOTIS"<eNOTISsupport@northwestern.edu>)

  # Uncomment below to get exeception_notifier working in development, see comment at http://agilewebdevelopment.com/plugins/exception_notifier
  # alias :rescue_action_locally :rescue_action_in_public
  # local_addresses.clear

  # Application version
  APP_VERSION = "0.0.1a"
  
  # Possible application statuses. See http://en.wikipedia.org/wiki/Bob_Dylan
  SYSTEM_STATUSES = { :up => "Don't think twice, it's alright",
                      :down => "Blowin' in the wind<br/>(down, we're working on it)",
                      :scheduled_maintenance => "The times they are a-changin'<br/>(down for scheduled maintenance)",
                      :scheduled_restored => "Like a rolling stone<br/>(scheduled maintenance complete)" }

  # TODO - make this actually reflect the system's status -yoon
  def system_status
    "up" #%w(up up up up up up up up up up up up up down scheduled_maintenance scheduled_restored).rand
  end
  
end
