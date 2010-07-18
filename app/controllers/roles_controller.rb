class RolesController < ApplicationController
  def show
    @user = User.find_by_netid(params[:id])
    payload = []
    @user.roles.each do |r|
      payload << {:consent_role => r.consent_role,
        :project_role => r.project_role,
        :irb_number => r.study.irb_number,
        :study_name => r.study.name}
    end
    respond_to do |format|
      format.json do
        render :json => payload
      end
    end
  end
end
