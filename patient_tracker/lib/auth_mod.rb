module AuthMod

  attr_accessor :_user

  def authenticate_user(user_name,password)
    current_user = User.find_and_validate(user_name,password)
  end

  def logged_in?
    if session[:current_user]
      @_user = User.find(session[:current_user])
      return true
    else
      return false
    end
    true
  end

  def user_must_be_logged_in
    unless logged_in?
      redirect_to authentication_index_path
    end
  end

  def current_user=(value)
    session[:current_user] = value.id
    @_user = User.find(value.id)
  end

  def current_user
    @_user || User.find(session[:current_user])
  end
end
