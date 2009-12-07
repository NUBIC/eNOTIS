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
        results = studies.map{|s| cols.map{|col| (col == "irb_number" ? (s.may_accrue? ? "<img src='images/status-on.png'/>" : "<img src='/images/status-off.png'/>") + "<a href='#{study_path(s)}' title='#{s.title}'>#{s.irb_number}</a>" : s.send(col))} }
        render :json => {:aaData => results, :iTotalRecords => results.size, :iTotalDisplayRecords => Study.count}
      end
    end
  end

  def show
    
    @study = Study.find_by_irb_number(params[:id])
    @study_events = InvolvementEvent.on_study(@study)
    @accruals = @study_events.with_event_types([DictionaryTerm.lookup_term("Consented",:event)])
    @events = %w(prescreened screened consented enrolled randomization withdrawn completed).map{|term| DictionaryTerm.lookup_term(term, :event)}
    # @events = DictionaryTerm.lookup_category_terms(:event).select{|dt| desired_terms.include? dt.term}
  end

end
