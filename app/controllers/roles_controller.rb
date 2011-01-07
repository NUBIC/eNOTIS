class RolesController < ApplicationController
  def show
    @user = User.find_by_netid(params[:id], :include => {:roles => :study})
    respond_to do |format|
      format.json do
        render :json => @user.roles.map{|r| {
          :consent_role => r.consent_role, 
          :project_role => r.project_role,
          :irb_number => r.study.irb_number,
          :study_name => r.study.name,
          :study_approved_date => (r.study.approved_date.nil?) ? r.study.approved_date : r.study.approved_date.strftime('%Y-%m-%d')
        } }
      end
      format.html
    end
  end
end
