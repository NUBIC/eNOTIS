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
    @medical_service = @study.medical_service || @study.create_medical_service
  end

  def update
    if params[:medical_service][:id]
      MedicalService.update(params[:medical_service][:id],params[:medical_service])
    end
  end

  def services_update

  end

end
