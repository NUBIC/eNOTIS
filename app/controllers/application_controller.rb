# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  # Helpers
  # helper :all # include all helpers, all the time
  
  # Security
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password # Scrub sensitive parameters from your log

  # Authentication used for all but one (Authentication) controller, enables before_filter :user_must_be_logged_in
  include ControllerAuthentication
  
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
  
  def validate_subject_params(params)
    errors = []
    if params[:mrn].blank?
      if params[:first_name].blank? and params[:last_name].blank? and Chronic.parse(params[:birth_date]).nil?
        errors << "We require an MRN OR first name, last name and Date of Birth"
      end
    end
    errors << "Race is a required field" unless !params[:race].blank?
    errors << "Gender AND Ethnicity are required fields" if params[:gender].blank? or params[:ethnicity].blank?
    errors << "Event AND corresponding Date are required fields" if params[:event_type].blank? or Chronic.parse(params[:event_date]).nil?
    return errors
  end 
end
