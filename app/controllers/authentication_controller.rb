class AuthenticationController < ApplicationController
  layout "layouts/public"
  auto_session_timeout_actions
  
  skip_before_filter :auto_session_timeout_filter, :only => :index
  skip_before_filter :verify_authenticity_token, :only => :login
  
  # Public instance methods (actions)
  def index
    # TODO System status check
    @filters = self.class.filter_chain
    @title = "measure, see, and improve your research"
    @studies_count = Study.count
    # @status = system_status
  end
  
  def login
    logout_keeping_session!
    user = User.authenticate(params[:netid], params[:password])

    if user
      # Protects against session fixation attacks, causes request forgery protection 
      # if user resubmits an earlier form using back button. Uncomment if you understand the tradeoffs.
      reset_session
      self.current_user = user
      redirect_back_or_default(default_path)
      flash[:notice] = "Logged in successfully as #{current_user.netid}"
    else
      note_failed_signin(user)
      @netid = params[:netid]
      # @status = system_status
      render :action => 'index'
    end
  end
  
  def logout
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(login_path) 
  end
  
  def help
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def active
    render_session_status
  end

  # Protected instance methods
  protected
  # Track failed login attempts
  def note_failed_signin(user)
    if user.nil?
      flash[:notice] = "Couldn't log you in as '#{params[:netid]}'<br/>Visit <a href='http://password.northwestern.edu'>password.northwestern.edu</a> for password help."
      logger.warn "Failed login for '#{params[:netid]}' from #{request.remote_ip} at #{Time.now.utc}"
    else
      flash[:notice] = "You are not currently associated with any IRB-approved studies as a PI, Co-Investigator, or Coordinator."
      logger.warn "Failed login, user doesn't exist for '#{params[:netid]}' from #{request.remote_ip} at #{Time.now.utc}"
    end
  end
  
end
