module AutoSessionTimeout
  
  def self.included(controller)
    controller.extend ClassMethods
    controller.hide_action :render_auto_session_timeout
  end
  
  module ClassMethods
    def auto_session_timeout(expiration, warning = 2.minutes)
      self.send(:define_method, :auto_session_timeout_filter) do
        if self.session[:auto_session_expires_at] && self.session[:auto_session_expires_at] < Time.now
          self.send :reset_session
        else
          unless self.send(:active_url) == self.url_for(self.params)
            self.session[:auto_session_expires_at] = Time.now + expiration
            self.session[:auto_session_warning_at] = self.session[:auto_session_expires_at] - warning
          end
        end      
      end
      prepend_before_filter :auto_session_timeout_filter
    end
    
    def auto_session_timeout_actions
      define_method(:active) { render_session_status }
      define_method(:timeout) { render_session_timeout }
    end
  end
  
  def render_session_status
    response.headers["Etag"] = ""  # clear etags to prevent caching
    if current_user?
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
    redirect_to "/logout"
  end
  
end

ActionController::Base.send :include, AutoSessionTimeout
