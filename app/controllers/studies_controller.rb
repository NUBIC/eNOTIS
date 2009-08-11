class StudiesController < ApplicationController
  layout "layouts/main"
  
  # Authentication
  before_filter :user_must_be_logged_in

  # Auditing
  has_view_trail :except => :index
  
  # Public instance methods (actions)
  def index
    respond_to do |format|
      format.html do
        @studies_count = Study.count
        @studies = []
      end
      # See http://datatables.net/forums/comments.php?DiscussionID=53 for json params
      format.json do
        query_cols = %w(irb_number title status)
        cols = %w(irb_number title status accrual)
        q = "%#{params[:sSearch]}%"
        order = (1..(params[:iSortingCols].to_i)).map{|i| [cols[(params["iSortCol_#{i-1}".to_sym].to_i || 0)], (params["iSortDir_#{i-1}"] || "ASC")].join(" ")}.join(",")
        results = Study.find( :all,
                              :select => "*, (SELECT COUNT(*) FROM involvements WHERE study_id = studies.id) AS accrual",
                              :offset => params[:iDisplayStart] || 0,
                              :limit => params[:iDisplayLength] || 10,
                              :order => order,
                              :conditions => [query_cols.map{|x| "#{x} LIKE ?"}.join(" OR "), q,q,q]).map{|s| cols.map{|col| (col == "irb_number" ? "<a href='#{study_path(s)}'>#{s.send(col)}</a>" : s.send(col))} }
        render :json => {:aaData => results, :iTotalRecords => results.size, :iTotalDisplayRecords => Study.count}
      end
    end
  end

  def show
    @study = Study.find_by_irb_number(params[:id])
    @study_events = InvolvementEvent.on_study(@study)
  end

end
