class Notifier < ActionMailer::Base
    
  def support_email
    %w(eNOTISsupport@northwestern.edu)
  end

  def study_upload_failure(upload)
    recipients support_email
    from support_email
    subject "[eNOTIS] Bulk Upload Failure"
    body :upload => upload
  end

  def pi_service_form(pi_email)
    from "r-chisholm@northwestern.edu"
    reply_to "d-gibson2@northwestern.edu"
    recipients pi_email
    subject "Identification of Research Studies making use of medical services"
    body 
  end
  
  def pi_service_reminder(person_email)
    from "r-chisholm@northwestern.edu"
    reply_to "d-gibson2@northwestern.edu"
    recipients person_email
    subject "Reminder: Identification of Research Studies making use of medical services"
    body 
  end

  def pi_service_final_reminder(pi_email, pi_name, cc_list, studies)
    from "r-chisholm@northwestern.edu"
    reply_to "d-gibson2@northwestern.edu"
    recipients pi_email
    cc cc_list
    subject "Final Reminder: Identification of Research Studies making use of medical services"
    body {:pi_name => pi_name, :studies => studies}

  end

  def proxy_service_form(to_emails, email_data)
    from "enotis@northwestern.edu"
    reply_to "enotis@northwestern.edu"
    recipients to_emails
    subject "Identification of Research Studies making use of medical servcies"
    body :email_data => email_data
  end
end
