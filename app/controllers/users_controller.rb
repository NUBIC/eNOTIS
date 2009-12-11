class UsersController < ApplicationController 
  layout "layouts/main"
  
  # Authentication
  before_filter :user_must_be_logged_in

  # Public instance methods (actions)

end
