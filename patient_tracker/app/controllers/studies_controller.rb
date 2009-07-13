class StudiesController < ApplicationController
  before_filter :user_must_be_logged_in
  layout "main"

  def index
    respond_to do |format|
      format.html do
        @studies_count = Study.count
        @studies = []
      end
      # What this means is that DataTables is now ideal for displaying huge amounts of data. DataTables will handle all of the events on the client-side, and send a request to the server for each draw it needs to make. The data fired back from the server will then be displayed. All the features of DataTables you know and love are supported, multi-column sorting, filtering, pagination etc. Obviously it's up to you to do the processing on the server-side and with your database interaction, but DataTables tells you what it needs through the following "get" variables:
      # 
      # iDisplayStart - Display start point
      # iDisplayLength - Number of records to display
      # sSearch - Global search field
      # # bEscapeRegex - Global search is regex or not (you probably don't want to enable this on the client-side!)
      # # iColumns - Number of columns being displayed (useful for getting individual column search info)
      # # sSearch_(int) - Individual column filter
      # # bEscapeRegex_(int) - Individual column filter is regex or not
      # iSortingCols - Number of columns to sort on
      # iSortCol_(int) - Column being sorted on (you will need to decode this number for your database)
      # iSortDir_(int) - Direction to be sorted
      # 
      # DataTables expects to receive a JSON object with this following properties:
      # 
      # iTotalRecords - Total records, after filtering (not just the records on this page, all of them)
      # iTotalDisplayRecords - Total records, before filtering
      # aaData - The data in a 2D array
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
    session[:study_irb_number] = params[:id]
    @study = Study.find(:first,:conditions=>["irb_number ='#{params[:id]}'"])
  end

end
