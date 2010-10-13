class SearchController < ApplicationController
  layout "main"

  # Authorization
  include Bcsec::Rails::SecuredController
  permit :user
  
  # Auditing
  has_view_trail

  # Public instance methods (actions)
  def show
    unless (q = params[:query]).blank?
      @subjects = current_user.subjects.first_name_or_last_name_like_any(q.split).paginate(:page => params[:page])
    end
    respond_to do |format|
      format.html do
        unless (q = params[:query]).blank?
          @studies = Study.title_or_name_or_irb_number_or_irb_status_like(q).paginate(:page => 1, :per_page => 30)#.paginate(:page => params[:page], :per_page => params[:per_page])
        end
      end
      format.json do
        return render :json=> {"aaData" => [], "iTotalRecords" => 0, "iTotalDisplayRecords" => 0, "sEcho" => params[:sEcho]} if params[:query].blank?
        columns = %w(irb_status irb_number name accrual accrual_goal)
        @studies = Study.title_or_name_or_irb_number_or_irb_status_like(params[:query]).order_by(columns[params[:iSortCol_0].to_i], params[:sSortDir_0]).paginate(:page => params[:iDisplayStart].to_i/params[:iDisplayLength].to_i + 1, :per_page => params[:iDisplayLength])
        render :template => "studies/index"
      end
    end
  end
  
  # Enables "post"
  def create
    show
    render :action => 'show'
  end
end
