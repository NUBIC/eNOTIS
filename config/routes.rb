ActionController::Routing::Routes.draw do |map|
  map.resources :authentication, :collection => {:login => :post, :logout => :any, :help => :get}
  map.resources :studies, :member => {:uploads => :get}
  map.resources :involvements, :collection => {:upload => :post}
  map.resource  :search, :controller => :search
  map.resources :reports
  map.hub       '/hub', {:controller => "admin", :action => "index"}
  map.active    '/active', {:controller => 'authentication', :action => 'active'}
  map.timeout   '/timeout', {:controller => 'authentication', :action => 'logout'}
  map.default   '', {:controller => "studies", :action => "index"}
end

