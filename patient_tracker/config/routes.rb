ActionController::Routing::Routes.draw do |map|
  map.resources :authentication, :collection => {:login => :post}
  map.resources :registration
  map.resources :protocols, :collection => {:search => :get}
  map.resources :patients, :collection => {:search => :get}
  map.default 'registration', {:controller => :registration_controller, :action => :index}
end

