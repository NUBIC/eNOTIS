class AdminController < ApplicationController
  include Bcsec::Rails::SecuredController  
  require_dependency 'activity'
  
  # Public instance methods (actions)
  def index
    redirect_to studies_path unless current_user.admin?
    @days_ago = 14
    @recent_handers = Activity.all(:conditions => ['controller =? AND action IN (?) AND created_at > ?', "involvements", %w(create update upload), @days_ago.days.ago]).group_by(&:whodiddit)
    @deadbeats = Activity.all(:conditions => ['whodiddit NOT IN (?)', Activity.find_all_by_action(%w(upload create update)).map(&:whodiddit).uniq]).group_by(&:whodiddit)
    @recent_uploads = StudyUpload.all(:include => :study, :order => "created_at DESC", :conditions => ['created_at > ?', @days_ago.days.ago])
  end
  
end
