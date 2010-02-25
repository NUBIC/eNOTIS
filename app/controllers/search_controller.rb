class SearchController < ApplicationController
  layout "layouts/main"
  
  # Authentication
  before_filter :user_must_be_logged_in
  
  # Auditing
  has_view_trail

  # Public instance methods (actions)
  def show
    unless (q = params[:query]).blank?
      @studies = Study.title_like(q) + Study.irb_status_like(q) + Study.irb_number_like(q)
      subjects_scope = Subject.involvements_study_id_equals_any(current_user.studies)
      @subjects = subjects_scope.first_name_like_any(q.split) + subjects_scope.last_name_like_any(q.split)
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
