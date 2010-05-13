class SearchController < ApplicationController
  layout "layouts/main"
  
  # Authentication
  before_filter :user_must_be_logged_in
  
  # Auditing
  has_view_trail

  # Public instance methods (actions)
  def show
    unless (q = params[:query]).blank?
      @studies = Study.title_or_name_or_irb_number_or_irb_status_like(q).all(:limit => 30)
      subjects_scope = Subject.involvements_study_id_equals_any(current_user.studies)
      @subjects = subjects_scope.first_name_or_last_name_like_any(q.split).all(:limit => 30)
    end
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end
  
  # Enables "post"
  def create
    show
    render :action => 'show'
  end
end
