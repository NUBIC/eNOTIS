class SearchController < ApplicationController
  before_filter :user_must_be_logged_in
  layout "main"
  def new
    
  end

end