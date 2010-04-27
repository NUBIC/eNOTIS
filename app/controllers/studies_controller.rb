class StudiesController < ApplicationController
  layout "layouts/main"
  require 'array'
  # Authentication
  before_filter :user_must_be_logged_in

  # Auditing
  has_view_trail :except => :index
  
  # Public instance methods (actions)
  def index
    @title = "Studies"
    # raise "testing exception notifier - yoon" # http://weblog.jamisbuck.org/2007/3/7/raising-the-right-exception
    respond_to do |format|
      format.html do
        @my_studies = current_user.studies
        # @studies_count = Study.count
        # @studies = []
      end
      # See http://datatables.net/forums/comments.php?DiscussionID=53 for json params
      format.json do
        query_cols = %w(irb_number pi_last_name)
        cols = %w(irb_number pi_last_name accrual)
        q = "%#{params[:sSearch]}%"
        order = (1..(params[:iSortingCols].to_i)).map{|i| [cols[(params["iSortCol_#{i-1}".to_sym].to_i || 0)], (params["iSortDir_#{i-1}"] || "ASC")].join(" ")}.join(",")
        studies = Study.find( :all,
                              :select => "*, (SELECT COUNT(*) FROM involvements WHERE study_id = studies.id) AS accrual",
                              :offset => params[:iDisplayStart] || 0,
                              :limit => params[:iDisplayLength] || 10,
                              :order => order,
                              :conditions => [query_cols.map{|x| "#{x} LIKE ?"}.join(" OR "), q,q])
        results = studies.map do |study|
          [ image_tag("/images/status-#{study.may_accrue? ? 'on' : 'off'}.png") + link_to(study_path(study), study.irb_number, :title => study.title),
            study.name,
            study.pi_last_name,
            study.accrual,
            study.accrual_goal]
        end
        render :json => {:aaData => results, :iTotalRecords => results.size, :iTotalDisplayRecords => Study.count}
      end
    end
  end

  def show
    @study = Study.find_by_irb_number(params[:id], :include => {:involvements => :involvement_events})
    if @study
      return redirect_with_message(default_path, :notice, "You don't have access to study #{@study.irb_number}") unless @study.has_coordinator?(current_user)
      @title = @study.irb_number
      @involvements = @study.involvements
      @ethnicity_stats = @involvements.count_all(:short_ethnicity)
      @gender_stats = @involvements.count_all(:short_gender)
      @race_stats = @involvements.count_all(:short_race)
    else
      redirect_to studies_path
    end
  end
  
  def import
    @study = Study.find_by_irb_number(params[:id])
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

end
