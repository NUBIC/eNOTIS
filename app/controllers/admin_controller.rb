class AdminController < ApplicationController
  # Authentication
  before_filter :user_must_be_logged_in
  before_filter :user_must_be_admin
  
  # Public instance methods (actions)
  def index
    @users = User.all
    @dictionary_terms = DictionaryTerm.all
  end
  
  protected
  
  def user_must_be_admin
    redirect_to default_path unless current_user.admin?
  end
end
