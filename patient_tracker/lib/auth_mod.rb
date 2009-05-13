module AuthMod

  def authenticate
    if session[:current_user]
      @current_user = session[:current_user]
    else
      redirect_to authentication_index_path
    end
  end

end
