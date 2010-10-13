class PublicController < ApplicationController
  skip_before_filter :auto_session_timeout_filter
  
  # Public instance methods (actions)
  def index
    # TODO System status check
    @filters = self.class.filter_chain
    @title = "measure, see, and improve your research"
    @studies_count = Study.count
    @users_count = Activity.count(:whodiddit, :distinct => true) # :conditions => ["created_at >= ?", 1.month.ago])
    @accrual_count = Involvement.count # (:conditions => ["updated_at >= ?", 1.month.ago])
    @cas_url = params[:logout] ? cas_logout_path : cas_login_path.to_s
  end
  
  def help
    @cas_url = params[:logout] ? cas_logout_path : cas_login_path.to_s
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end
  
  def active
    response.headers["Etag"] = ""  # clear etags to prevent caching
    if current_user
      if session[:auto_session_expires_at] <= Time.now
        @status = 'expired'
      elsif session[:auto_session_warning_at] <= Time.now  
        @status = 'warning'
      else
        @status = 'active'
      end
    else
      @status = 'expired'
    end
    render :text => @status, :status => 200
  end

  # Protected instance methods
  protected
  def cas_login_path
    uri = URI.join(Bcsec.configuration.parameters_for(:cas)[:base_url], 'login')
    uri.query = "service=#{request.scheme}://#{request.host}#{params[:return]}"
    return uri.to_s
  end
  def cas_logout_path
    uri = URI.join(Bcsec.configuration.parameters_for(:cas)[:base_url], 'logout')
    uri.query = "service=#{request.scheme}://#{request.host}"
    return uri.to_s
  end
end
