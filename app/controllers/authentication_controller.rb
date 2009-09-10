class AuthenticationController < ApplicationController
  layout "layouts/public"

  # Public instance methods (actions)
  def index
    # TODO System staus check
    @title = "Clinical Registration System"
    @status = system_status
  end
  
  def login
    logout_keeping_session!
    user = User.authenticate(params[:netid], params[:password])

    if user
      # Protects against session fixation attacks, causes request forgery protection if user resubmits an earlier form using back button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      redirect_back_or_default(default_path)
      flash[:notice] = "Logged in successfully as #{current_user.netid}"
    else
      note_failed_signin
      @netid = params[:netid]
      @status = system_status
      render :action => 'index'
    end
  end
  
  def logout
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(authentication_index_path) 
  end
  
  def access_help
  end
  
  # Protected instance methods
  protected
  # Track failed login attempts
  def note_failed_signin
    flash[:notice] = "Couldn't log you in as '#{params[:netid]}'<br/>Visit <a href='http://password.northwestern.edu'>password.northwestern.edu</a> for password help."
    logger.warn "Failed login for '#{params[:netid]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
  
end
