# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base  
  # Helpers
  # helper :all # include all helpers, all the time
  
  # Security
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password, :involvement, :subject # Scrub sensitive parameters from your log

  # Rails basic session timeout is set in config/initializers/session_store.rb to 30 mins, shorter than the CAS 6 hour (for single sign-on) timeout  
  # This code (along with jquery.sessionTimeout.js) automatically shows an overlay after 5 minutes of inactivity, and gets "/" after 30 mins
  before_filter :auto_session_timeout_filter
  
  def auto_session_timeout_filter
    if self.session[:auto_session_expires_at] && self.session[:auto_session_expires_at] < Time.now
      self.send :reset_session
    else
      unless self.send(:active_url) == self.url_for(self.params)
        self.session[:auto_session_expires_at] = Time.now + 30.minutes
        self.session[:auto_session_warning_at] = self.session[:auto_session_expires_at] - 25.minutes
      end
    end      
  end
  
  # Exception Notifier
  include ExceptionNotifiable
  ExceptionNotifier.exception_recipients = %w(eNOTISsupport@northwestern.edu)
  ExceptionNotifier.sender_address = %("eNOTIS"<eNOTISsupport@northwestern.edu>)
  # Uncomment below to get exeception_notifier working in development, see comment at http://agilewebdevelopment.com/plugins/exception_notifier
  # alias :rescue_action_locally :rescue_action_in_public
  # local_addresses.clear

  # Application version
  APP_VERSION = "1.11.3"

  def redirect_with_message(path, message_type, message)
    flash[message_type] = message if !message.blank? and !message_type.blank?
    redirect_to path
  end

  # Overriding the paper and view trail methods for the current_user method
  def user_for_paper_trail
    current_user.blank? ? nil : current_user.username
  end

  # current_user better be a bcsec user with a username attr or this will blow up
  def set_whodiddit
    @@whodiddit = lambda {
      self.respond_to?(:current_user) ? self.current_user.username : nil
    }
  end
end
