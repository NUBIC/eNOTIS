ActionController::Routing::Routes.draw do |map|
  map.resources :authentication, :collection => {:login => :post, :logout => :any}
  map.resources :registrations,:collection => {:search => :post,:add_patient => :post }
  map.resources :protocols, :collection => {:search => :get}
  map.resources :patients, :collection => {:search => :get}

  map.connect 'registration', {:controller => "registrations", :action => "index"}
  map.default '', {:controller => "registrations", :action => "index"}
end

