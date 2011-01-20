class ServicesController < ApplicationController
  # Authorization
  include Bcsec::Rails::SecuredController
  permit :user
  
  def index
    @studies = current_user ? current_user.studies : []
  end
  def edit
    @study = Study.find_by_irb_number(params[:id])
    return redirect_to services_path unless @study
    @service_report = @study.service_reports.last || @study.service_reports.build
  end
end
