ActionController::Routing::Routes.draw do |map|
  map.resources :authentication, :collection => {:login => :post}
end

