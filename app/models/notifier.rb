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

  def pi_service_form(pi_email)
    from "r-chisholm@northwestern.edu"
    reply_to "d-gibson2@northwestern.edu"
    recipients pi_email
    subject "Identification of Research Studies making use of medical services"
    body 
  end

  def proxy_service_form(to_emails, email_data)
    from "enotis@northwestern.edu"
    reply_to "enotis@northwestern.edu"
    recipients to_emails
    subject "Identification of Research Studies making use of medical servcies"
    body :email_data => email_data
  end
end
