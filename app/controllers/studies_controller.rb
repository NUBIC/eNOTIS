class StudiesController < ApplicationController
  layout "main"
  require 'array'

  # Authorization
  include Bcsec::Rails::SecuredController
  permit :user

  # Auditing
  has_view_trail :except => :index
  
  # Public instance methods (actions)
  def index
    @title = "Studies"
    # raise "testing exception notifier - yoon" # http://weblog.jamisbuck.org/2007/3/7/raising-the-right-exception
    respond_to do |format|
      format.html do
        @my_studies = current_user.studies.paginate(:page=>params[:page], :per_page=>params[:per_page])
      end
      # See http://datatables.net/forums/comments.php?DiscussionID=53 for json params
      format.json do
        colName  = ["irb_status" , "irb_number", 'name', 'last_name', 'accrual', 'accrual_goal']
        order                 = colName[params[:iSortCol_0].to_i] + " " + params[:sSortDir_0]
        all_studies           = StudyTable.user_id_is(current_user.id).order(order)
        @studies              = all_studies.paged(params[:iDisplayStart], params[:iDisplayLength])
        @iTotalDisplayRecords = all_studies.size
        @sEcho                = params[:sEcho].to_i
      end
    end
  end

  def show
    @study = Study.find_by_irb_number(params[:id], :include => [{:involvements => [{:subject => :involvements}, :involvement_events]}, {:roles => :user}])
    if @study
      return redirect_with_message(default_path, :notice, "You don't have access to study #{@study.irb_number}") unless @study.has_coordinator?(current_user)
      @title = @study.irb_number
      @involvements = @study.involvements
      unless @involvements.empty?        
        @ethnicity_stats = @involvements.count_all(:short_ethnicity)
        @gender_stats = @involvements.count_all(:short_gender)
        @race_stats = @involvements.count_all(:short_race)
        @time_stats = InvolvementEvent.accruals.on_study(@study).to_time_chart
        @dot_stats = InvolvementEvent.accruals.on_study(@study).to_dot_chart.inspect
      end
    else
      redirect_to studies_path
    end
  end
  
  def import
    @study = Study.find_by_irb_number(params[:id])
    @uploads = @study.study_uploads
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end
end