class ServicesController < ApplicationController
  # Authorization
  include Bcsec::Rails::SecuredController
  permit :user
  
  def index
    @title = "Medical Services"
    @studies = current_user ? current_user.studies : []
    @service_studies = @studies.select{|s| s.uses_medical_services == true }
  end

  def edit
    @title = "Medical Services Form"
    @study = Study.find_by_irb_number(params[:id])
    return redirect_to services_path unless @study
    @medical_service = @study.medical_service || @study.build_medical_service
  end

  def update

  end

end
