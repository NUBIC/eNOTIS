ActionController::Routing::Routes.draw do |map|
  map.resources :authentication, :collection => {:login => :post}
  map.resources :registration
end

