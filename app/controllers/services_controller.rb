class ServicesController < ApplicationController
  layout "main"

  # Authorization
  include Bcsec::Rails::SecuredController
  permit :user
  
  def index
    @title = "Medical Services"
    all_studies = current_user ? current_user.studies : []
    @studies = all_studies.reject{|s| !s.closed_or_completed_date.nil? }
    @not_reported_yet = !@studies.select{|s| s.uses_medical_services.nil?}.empty?
    @service_studies = @studies.select{|s| s.uses_medical_services == true }
    # Done when all @service_studies have completed medical_services forms
    unless @not_reported_yet
      @done = @service_studies.select{|s| s.medical_service.nil? || !s.medical_service.completed?}.empty? 
    end
  end


  def edit
    @study = Study.find_by_irb_number(params[:id])
    return redirect_to services_path unless @study
    @title = "Medical Services Form :: #{@study}"
    @medical_service = @study.medical_service || @study.create_medical_service
  end

  def update
    if params[:medical_service][:id]
      MedicalService.update(params[:medical_service][:id],params[:medical_service])
      flash[:notice] = "Updated Medical Services Form"
    else
      flash[:notice] = "Missing Service Form ID"
    end
    redirect_to services_path
  end

  def services_update
    params[:study].each do |k,v|
      study = Study.find(k)
      if study 
        study.uses_medical_services = v[:uses_medical_services]
        study.save!
      end
    end
    flash[:notice] = "Study Services Updated"
    redirect_to services_path
  end

end
