module ControllerAuthentication

  protected
    # Returns true or false if the user is logged in. Preloads @current_user with the user model if they're logged in.
    def logged_in?
      !!current_user
    end

    # Accesses the current user from the session. Future calls avoid the database because nil is not equal to false.
    def current_user
      @current_user ||= (login_from_session) unless @current_user == false
    end

    # Store the given user id in the session.
    def current_user=(new_user)
      session[:user_id] = new_user ? new_user.id : nil
      @current_user = new_user || false
    end

    # Check if the user is authorized
    def authorized?(action = action_name, resource = nil)
      logged_in? and (current_user.admin? or !current_user.studies.empty?)
    end

    # Filter method to enforce a login requirement.
    # To require logins for all actions, use this in your controllers: before_filter :login_required
    # To require logins for specific actions, use this in your controllers: before_filter :login_required, :only => [ :edit, :update ]
    # To skip this in a subclassed controller:  skip_before_filter :login_required
    def user_must_be_logged_in
      authorized? || access_denied
    end

    # Redirect as appropriate when an access request fails. The default action is to redirect to the login screen. Override this method in your controllers if you want to have special behavior in case the user is not authorized to access the requested action.  For example, a popup window might simply close itself.
    def access_denied
      store_location
      flash[:notice] = "You are not currently associated with any IRB-approved studies as a PI, co-Investigator, or Coordinator. Please contact the eIRB." if logged_in?
      redirect_to login_path
    end

    # Store the URI of the current request in the session. We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.request_uri
    end

    # Redirect to the URI stored by the most recent store_location call or to the passed default. Set an appropriately modified after_filter :store_location, :only => [:index, :new, :show, :edit] for any controller you want to be bounce-backable.
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    # Inclusion hook to make #current_user and #logged_in? available as ActionView helper methods.
    def self.included(base)
      base.send :helper_method, :current_user, :logged_in?, :authorized? if base.respond_to? :helper_method
    end

    # Login
    # Called from #current_user.  First attempt to login by the user id stored in the session.
    def login_from_session
      self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
    end
  
    # Logout
    # This is ususally what you want; resetting the session willy-nilly wreaks
    # havoc with forgery protection, and is only strictly necessary on login.
    # However, **all session state variables should be unset here**.
    def logout_keeping_session!
      # Kill server-side auth cookie
      @current_user.forget_me if @current_user.is_a? User
      @current_user = false     # not logged in, and don't do it for me
      session[:user_id] = nil   # keeps the session but kill our variable
      # explicitly kill any other session variables you set
    end

    # The session should only be reset at the tail end of a form POST --
    # otherwise the request forgery protection fails. It's only really necessary
    # when you cross quarantine (logged-out to logged-in).
    def logout_killing_session!
      logout_keeping_session!
      reset_session
    end

end
