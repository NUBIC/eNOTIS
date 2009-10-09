ActionController::Routing::Routes.draw do |map|
  map.resources :authentication, :collection => {:login => :post, :logout => :any, :access_help => :get}
  map.resources :studies
  map.resources :reports
  map.resources :subjects, :collection => {:search=>:get,:merge=>:post}
  map.resources :users, :collection => {:dashbaord => :get,:session_tracker=>:get}
  map.resources :involvement_events, :collection => [:search]
  map.resource  :search, :controller => :search
  map.hub       '/hub', {:controller => "admin", :action => "index"}
  map.dashboard '/dashboard', {:controller => "users", :action => "dashboard"}
  map.active '/active', :controller => 'authentication', :action => 'active'
  map.timeout '/timeout', :controller => 'authentication', :action => 'logout'
  map.default   '', {:controller => "users", :action => "dashboard"}
end

