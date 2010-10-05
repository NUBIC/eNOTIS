class SearchController < ApplicationController
  layout :main

  # Authorization
  include Bcsec::Rails::SecuredController
  permit :user
  
  # Auditing
  has_view_trail

  # Public instance methods (actions)
  def show
    unless (q = params[:query]).blank?
      subjects_scope = Subject.involvements_study_id_equals_any(current_user.studies)
      @subjects = subjects_scope.first_name_or_last_name_like_any(q.split).paginate(:page => params[:page])
    end
    respond_to do |format|
      format.html do
        unless (q = params[:query]).blank?
          @studies = Study.title_or_name_or_irb_number_or_irb_status_like(q).paginate(:page => 1, :per_page => 30)#.paginate(:page => params[:page], :per_page => params[:per_page])
        end
      end
      format.json do
        colName  = ["irb_status" , "irb_number", 'name', 'last_name', 'accrual', 'accrual_goal']
        order    = colName[params[:iSortCol_0].to_i] + " " + params[:sSortDir_0]#
        if params[:query] && !params[:query].blank?
          all_studies     = StudyTable.title_or_name_or_irb_number_or_irb_status_like(params[:query])#.project_role_is("Principal Investigator")
          @studies         = all_studies.paged(params[:iDisplayStart], params[:iDisplayLength])
          @display_records = all_studies.size
          @sEcho = params[:sEcho].to_i
        else
          render :json=> {"aaData" => [], "iTotalRecords" => 0, "iTotalDisplayRecords" => 0, "sEcho" => params[:sEcho]}
        end
      end
    end
  end
  
  # Enables "post"
  def create
    show
    render :action => 'show'
  end
end
