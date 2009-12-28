ActionController::Routing::Routes.draw do |map|
  map.resources :authentication, :collection => {:login => :post, :logout => :any, :help => :get}
  map.resources :studies
  map.resources :reports
  map.resources :subjects, :collection => {:search => :get, :merge => :post}
  map.resources :users
  map.resources :involvement_events, :collection => [:search]
  map.resource  :search, :controller => :search
  map.hub       '/hub', {:controller => "admin", :action => "index"}
  map.active    '/active', {:controller => 'authentication', :action => 'active'}
  map.timeout   '/timeout', {:controller => 'authentication', :action => 'logout'}
  map.default   '', {:controller => "studies", :action => "index"}
end

