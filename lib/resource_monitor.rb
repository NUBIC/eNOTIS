#Dir["lib/webservices/plugins/*.rb"].each {|file| require file}
require File.expand_path(File.dirname(__FILE__) + "/../config/environment") unless defined?(RAILS_ROOT)
Dir[File.dirname(__FILE__) + "/webservices/plugins/*.rb"].each {|file| require file}
#check the EDW status
loop do
 [EdwServices,EirbServices].each do |service|
   status,message = service.service_test
   ResourceStatus.find_by_name(service.to_s.downcase).update_attributes({:status=>status,:message=>message})
 end
   sleep(1800)
end


#TODO complete activemq monitoring
