class AdminController < ApplicationController
  include Bcsec::Rails::SecuredController
  permit :admin
  
  require_dependency 'activity'
  
  # Public instance methods (actions)
  def index
    @involvement_events = InvolvementEvent.all(:include => {:involvement => :study}, :conditions => {:studies => {:read_only => nil}}).group_by(&:event)
    @active_users = Activity.all(:order => "created_at DESC").group_by(&:whodiddit)
    @active_studies = Involvement.all(:include => :study, :conditions => {:studies => {:read_only => nil}}, :order => "involvements.updated_at DESC").group_by(&:study)
    @recent_uploads = StudyUpload.all(:include => [:user, :study], :order => "created_at DESC")
  end
  
end
