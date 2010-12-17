class AdminController < ApplicationController
  include Bcsec::Rails::SecuredController  
  require_dependency 'activity'
  
  # Public instance methods (actions)
  def index
    redirect_to studies_path unless current_user.admin?
    @involvement_events = InvolvementEvent.all(:include => {:involvement => :study}, :conditions => {:studies => {:read_only => nil}}).group_by(&:event)
    @active_users = Activity.all(:order => "created_at DESC").group_by(&:whodiddit)
    @active_studies = Involvement.all(:include => :study, :conditions => {:studies => {:read_only => nil}}, :order => "involvements.updated_at DESC").group_by(&:study)
    @recent_uploads = StudyUpload.all(:include => :study, :order => "created_at DESC")
  end
  
end
