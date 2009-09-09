
#Represents a a system resource that is part of eNOTIS e.g edw
#keeps information on status and error message(if any)
class ResourceStatus < ActiveRecord::Base
   after_update :notifier


   protected
   def notifier
      if self.status_changed? or self.message_changed?
        Notifier.send :deliver_service_status_notification,self  
      end
   end
end
