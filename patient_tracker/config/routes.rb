ActionController::Routing::Routes.draw do |map|
  map.resources :authentication, :collection => {:login => :post, :logout => :any}
  map.resources :registrations,:collection => {:search => :post,:add_subject => :post }
  map.resources :studies, :collection => {:search => :get}
  map.resources :subjects, :collection => {:search => :get}

  map.connect 'registration', {:controller => "registrations", :action => "index"}
  map.default '', {:controller => "registrations", :action => "index"}
end

