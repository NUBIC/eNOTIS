class AdminController < ApplicationController
  include Bcsec::Rails::SecuredController  
  require_dependency 'activity'
  before_filter :require_admin
  
  # Public instance methods (actions)
  def index
    @days_ago = 14
    @recent_handers = Activity.all(:conditions => ['controller =? AND action IN (?) AND created_at > ?', "involvements", %w(create update upload), @days_ago.days.ago]).group_by(&:whodiddit)
    @deadbeats = Activity.all(:conditions => ['whodiddit NOT IN (?)', Activity.find_all_by_action(%w(upload create update)).map(&:whodiddit).uniq]).group_by(&:whodiddit)
    @recent_uploads = StudyUpload.all(:include => :study, :order => "created_at DESC", :conditions => ['created_at > ?', @days_ago.days.ago])
  end
  def pi_report
    range = Date.parse("1/1/#{params[:year]}")..Date.parse("12/31/#{params[:year]}")
    study_ids = InvolvementEvent.all(:conditions => {:occurred_on => range}, :include => :involvement).map{|ie| ie.involvement.study_id}.uniq
    studies = Study.find(study_ids, :include => :roles)
    csv_string = FasterCSV.generate do |csv|
      csv << %w(Study Title PI\ First PI\ Last PI\ E-mail PI\ netID)
      studies.each do |study|
        pi = study.principal_investigator
        if pi && u = Bcsec.authority.find_user(pi.netid)
          csv << [study.irb_number, study.name, u.first_name, u.last_name, u.email, u.netid]
        else
          csv << [study.irb_number, study.name, nil, nil, nil, pi ? pi.netid : nil]
        end
      end
    end
    send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => "enotis_pi_#{params[:year]}.csv")
  end


  def imports
    render(:text => "imports")
  end

  private
  
  def require_admin
    redirect_to studies_path unless current_user.permit? :admin
  end
end
