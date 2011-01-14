class PublicController < ApplicationController

  # Public instance methods (actions)
  def index
    redirect_to params[:return] || default_path if current_user
    # TODO System status check
    @filters = self.class.filter_chain
    @title = "measure, see, and improve your research"
    @studies_count = Study.count
    @users_count = Activity.count(:whodiddit, :distinct => true) # :conditions => ["created_at >= ?", 1.month.ago])
    @accrual_count = Involvement.count # (:conditions => ["updated_at >= ?", 1.month.ago])
    @cas_login_url = cas_login_path.to_s
  end
  
  def help
    @cas_url = params[:logout] ? cas_logout_path : cas_login_path.to_s
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end
  
  # Protected instance methods
  protected
  def cas_base_url
    # make agnostic to cas_base_url or base_url. base_url is preferred
    config = Bcsec.configuration.parameters_for(:cas)
    config[:base_url] || config[:cas_base_url]
  end
  def cas_login_path
    uri = URI.join(cas_base_url, 'login')
    uri.query = "service=#{request.scheme}://#{request.host}#{params[:return]}"
    return uri.to_s
  end
  def cas_logout_path
    uri = URI.join(cas_base_url, 'logout')
    uri.query = "service=#{request.scheme}://#{request.host}"
    return uri.to_s
  end
end
