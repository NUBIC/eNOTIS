class AdminController < ApplicationController
  # Authentication
  before_filter :user_must_be_logged_in
  before_filter :user_must_be_admin
  
  require_dependency 'activity'
  
  # Public instance methods (actions)
  def index
    @involvement_events = InvolvementEvent.all(:include => {:involvement => :study}, :conditions => {:studies => {:read_only => nil}}).group_by(&:event)
    @active_users = Activity.all(:include => :user, :order => "created_at DESC").group_by(&:user)
    @active_studies = Involvement.all(:include => :study, :conditions => {:studies => {:read_only => nil}}, :order => "involvements.updated_at DESC").group_by(&:study)
    @recent_uploads = StudyUpload.all(:include => [:user, :study], :order => "created_at DESC")
  end
  
  protected
  
  def user_must_be_admin
    redirect_to default_path unless current_user.admin?
  end
end
