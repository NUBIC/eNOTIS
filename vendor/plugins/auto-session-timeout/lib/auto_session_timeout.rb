module AutoSessionTimeout
  
  def self.included(controller)
    controller.extend ClassMethods
    controller.hide_action :render_auto_session_timeout
  end
  
  module ClassMethods
    def auto_session_timeout(expiration,warning=2.minutes)
      prepend_before_filter do |c|
        if c.session[:auto_session_expires_at] && c.session[:auto_session_expires_at] < Time.now
          c.send :reset_session
        else
          unless c.send(:active_url) == c.url_for(c.params)
            c.session[:auto_session_expires_at] = Time.now + expiration
            c.session[:auto_session_warning_at] = c.session[:auto_session_expires_at] - warning
          end
        end
      end
    end
    
    def auto_session_timeout_actions
      define_method(:active) { render_session_status }
      define_method(:timeout) { render_session_timeout }
    end
  end
  
  def render_session_status
    response.headers["Etag"] = ""  # clear etags to prevent caching
    if logged_in?
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
  
  def render_session_timeout
    flash[:notice] = "Your session has timed out."
    redirect_to "/login"
  end
  
end

ActionController::Base.send :include, AutoSessionTimeout
