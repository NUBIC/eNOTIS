class ServicesController < ApplicationController
  layout "main"

  # Authorization
  #include Bcsec::Rails::SecuredController
  #permit :user, :oversight
  before_filter :require_user

  # Users complained we lost their data because we had this in
  skip_before_filter :verify_authenticity_token
   
  # Auditing
  has_view_trail  
  
  def index
    @title = "Medical Services"
    all_studies = current_user ? current_user.studies : []

    # Study status
    # Approved
    # Assigned to Meeting
    # Assigned To Meeting: Changes Requested
    # Awaiting Approval Correspondence
    # Awaiting Coordinator Assignment
    # Awaiting Expedited Reviewer Assignment
    # Changes Requested by Dept Reviewer
    # Changes Requested By OPRS Staff
    # Changes Required by IRB
    # x Closed/Terminated
    # Completed
    # Conditional Approval
    # Dept Site Anc Review
    # Designated Reviewer Conditions Review
    # x Exempt Approved
    # x Exempt Review: Changes Requested
    # x Expedited Review: Awaiting Correspondence
    # x Expedited Review: Changes Requested
    # x Expired
    # Expired: Periodic Review In Progress
    # x In Expedited Review
    # OPRS Staff Conditions Review
    # OPRS Staff Review
    # x Original Version
    # x Pre Submission
    # x Rejected
    # Suspended
    # x Withdrawn
    to_remove = [ "Withdrawn", "Rejected", "Exempt Review: Changes Requested",
      "Original Version", "In Expedited Review", "Expired", "Expedited Review: Changes Requested",
      "Expedited Review: Awaiting Correspondence", "Exempt Review: Changes Requested",
      "Exempt Approved","Closed/Terminated", "Pre Submission"]

    @studies = all_studies.reject{ |s|  !s.closed_or_completed_date.nil? or to_remove.include?(s.irb_status)  }
    # HACK - added to handle the rush-request to give people not on IRB roles access to fill out this stupid medical services form
    if current_user.permit?(:oversight)
      # Look up user in oversight list
      proxy_file = File.open(RAILS_ROOT + "/lib/proxy_study_list.yaml")
      proxies = YAML.load(proxy_file)
      proxies.each do |proxy|
        if proxy[:proxies] && proxy[:proxies].include?(current_user.username)
          proxy[:studies].each do |irb_number|
            study = Study.find_by_irb_number(irb_number) 
            @studies << study unless to_remove.include?(study.irb_status)
          end
        end
      end
    end
    @studies = @studies.uniq
    @service_studies = @studies.select{|s| s.uses_medical_services == true } || []
    # Done when all @service_studies have completed medical_services forms
    unless @service_studies.empty?
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
