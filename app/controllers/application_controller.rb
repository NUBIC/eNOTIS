# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base  
  # Helpers
  # helper :all # include all helpers, all the time
  
  # Security
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password, :involvement, :subject unless Rails.env == "development" # Scrub sensitive parameters from your log

  after_filter :flash_headers

  # Rails basic session timeout is set in config/initializers/session_store.rb to 30 mins, shorter than the CAS 6 hour (for single sign-on) timeout  
  # Client-side javascript shows an overlay after 5 minutes of inactivity, and gets "/studies" after 30 mins
  
  # Exception Notifier
  include ExceptionNotifiable
  ExceptionNotifier.exception_recipients = %w(eNOTISsupport@northwestern.edu)
  ExceptionNotifier.sender_address = %("eNOTIS"<eNOTISsupport@northwestern.edu>) 
  ExceptionNotifier.email_prefix = " [#{Rails.env}] "
  # Uncomment below to get exeception_notifier working in development, see comment at http://agilewebdevelopment.com/plugins/exception_notifier
  # alias :rescue_action_locally :rescue_action_in_public
  # local_addresses.clear

  #can can redirect for unauthorized error
  rescue_from CanCan::AccessDenied do |exception|
    flash[:notice]="Access Denied"
    return redirect_to studies_path
  end 

  #
  # Application version
  APP_VERSION = "2.1.2"



  def require_user
    unless current_user and current_user.has_system_access?
      store_location
      current_user.nil? ? flash[:notice] = "Please login to access this page" : flash[:notice] = "Access Denied"
      current_user.nil? ? (redirect_to login_url) : (redirect_to '/logout')
      return false
    end
  end


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

  def flash_headers
    # This will discontinue execution if Rails detects that the request is not
    # from an AJAX request, i.e. the header wont be added for normal requests
    return unless request.xhr?
         
    # add flash notices to reesponse header
    response.headers['x-flash'] = flash[:error]  unless flash[:error].blank?
    response.headers['x-flash'] = flash[:notice]  unless flash[:notice].blank?
                    
    # Stops the flash appearing when you next refresh the page
    flash.discard
  end

  private

  def store_location
    session[:return_to] = request.request_uri
  end
end
