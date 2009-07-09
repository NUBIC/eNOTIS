class StudiesController < ApplicationController
  before_filter :user_must_be_logged_in
  layout "main"

  def index
    respond_to do |format|
      format.html { @studies = [] } 
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
        cols = %w(irb_number title status)
        q = "%#{params[:sSearch]}%"
        order = (params[:iSortingCols] || 1).to_i.times.map{|i| [cols[(params["iSortCol_#{i}".to_sym].to_i || 0)], (params["iSortDir_#{i}"] || "ASC")].join(" ")}.join(",")
        results = Study.find( :all,
                              :offset => params[:iDisplayStart] || 0,
                              :limit => params[:iDisplayLength] || 10,
                              :order => order,
                              :conditions => [cols.map{|x| "#{x} LIKE ?"}.join(" OR "), q,q,q]
                            ).map{|s| cols.map{|col| s.send(col)} }
        render :json => {:aaData => results, :iTotalRecords => results.size, :iTotalDisplayRecords => Study.count}
      end
    end

    

    
  end
	
  def show
    session[:study_id] = params[:id]
    @study = Study.find_by_id(params[:id])
  end
	
  def search
    if params[:query] and @study = (Study.find_by_irb_number(params[:query]) || Study.find(:first, :conditions => [ "title like ?", "%#{params[:query]}%"]) )
      render(:action => "show")
    else
      flash[:notice] = "No studies found"
      redirect_to :back
    end
  end

end
