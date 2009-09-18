class Notifier < ActionMailer::Base


 def support_email
 #%w(eNOTISsupport@northwestern.edu)
   "d-were@northwestern.edu"
 end

 def service_status_notification(service)
   recipients support_email
   from support_email
   subject "[eNOTIS]#{service.name.upcase}: Status - #{service.status ? "up" : "down"}"
   body :service => service
 end
  

end
