module AuthMod


  def authenticate_user(user_name,password)
    self.current_user = User.find_and_validate(user_name,password)
  end

  def logged_in?
    if session[:current_user] and (@current_user = User.find(:first, :conditions => ["id=?",session[:current_user]]))
        return true
    else
      return false
    end
  end

  def logout_user
    reset_session
    @current_user = nil
  end

  def user_must_be_logged_in
    unless logged_in?
      redirect_to authentication_index_path
    end
  end

  def current_user=(value)
    session[:current_user] = value.id
    @current_user = value
  end

  def current_user
    if @current_user 
      @current_user
    elsif session[:current_user]
      @current_user = User.find(session[:current_user])
    else
      nil
    end
  end

end
