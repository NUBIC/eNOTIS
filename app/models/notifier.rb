class Notifier < ActionMailer::Base
    
  def support_email
    # %w(eNOTISsupport@northwestern.edu)
    "d-were@northwestern.edu"
  end

  def service_status_notification(service)
    recipients support_email
    from support_email
    subject "[eNOTIS]#{service.name.upcase}: Status - #{service.status ? "up" : "down"}"
    body :service => service
  end

  def study_upload_failure(upload)
    recipients support_email
    from support_email
    subject "[eNOTIS] Bulk Upload Failure"
    body :upload => upload
  end

  def daily_failed_jobs
    from "enotissupport@northwestern.edu"
    recipients "enotissupport@northwestern.edu"
    subject "[Resque] eNOTIS Daily Job Failure Count - #{Rails.env}"
    body "#{Resque::Failure.count} jobs failed today on eNOTIS #{Rails.env}"
  end

  def pi_service_form(pi_email, sent_by)
    from sent_by
    recipients pi_email
    subject "Deadline Feb. 4th - Medical Services Form for Clinical Research"
    body 
  end

end
