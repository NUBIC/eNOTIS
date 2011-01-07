class RolesController < ApplicationController
  def show
    @user = Bcsec.authority.find_user(params[:id])
    @roles = Role.find_all_by_netid(params[:id], :include => {:study => [:involvement_events, :event_types]})
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
