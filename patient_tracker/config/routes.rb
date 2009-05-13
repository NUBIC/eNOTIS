ActionController::Routing::Routes.draw do |map|
  map.resources :authentication, :collection => {:login => :post}
  map.resources :registration

  map.default 'registration', {:controller => :registration_controller, :action => :index}
end

