ActionController::Routing::Routes.draw do |map|
  map.resources :authentication, :collection => {:login => :post, :logout => :any}
  map.resources :registrations
  map.resources :protocols, :collection => {:search => :get}
  map.resources :patients, :collection => {:search => :get}
  map.default 'registration', {:controller => "registrations", :action => "index"}
end

