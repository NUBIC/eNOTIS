ActionController::Routing::Routes.draw do |map|
  map.resources :authentication, :collection => {:login => :post, :logout => :any, :access_help => :get}
  map.resources :studies
  map.resources :subjects, :collection => {:search=>:get,:sync=>:post}
  map.resources :users, :collection => {:dashbaord => :get}
  map.resources :involvement_events, :collection => [:search]
  map.resource  :search, :controller => :search
  map.hub       '/hub', {:controller => "admin", :action => "index"}
  map.dashboard '/dashboard', {:controller => "users", :action => "dashboard"}
  map.default   '', {:controller => "users", :action => "dashboard"}
end

