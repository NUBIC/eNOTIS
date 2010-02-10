#
# Add your destination definitions here
# can also be used to configure filters, and processor groups
#
ActiveMessaging::Gateway.define do |s|
  #s.destination :orders, '/queue/Orders'
  #s.filter :some_filter, :only=>:orders
  #s.processor_group :group1, :order_processor
  s.destination :external_event, "/queue/eNOTIS_#{Rails.env.capitalize}_ExternalEvents"
  s.destination :external_event_error, "/queue/eNOTIS_#{Rails.env.capitalize}_ExternalEventsError"
end
