ActionController::Routing::Routes.draw do |map|
  map.resources :authentication, :collection => {:login => :post, :logout => :any}
  map.resources :studies, :collection => {:search => :get}
  map.resources :subjects, :collection => {:search => :get}
  map.resources :users, :collection => {:dashbaord => :get}
  
  map.resources :involvement_events, :collection => {:search => :post}
  
  map.dashboard '/dashboard', {:controller => "users", :action => "dashboard"}
  map.default '', {:controller => "users", :action => "dashboard"}

  # map.resources :registrations,:collection => {:search => :post,:add_subject => :post }
  # map.connect 'registration', {:controller => "registrations", :action => "index"}


end

