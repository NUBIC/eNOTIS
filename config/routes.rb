ActionController::Routing::Routes.draw do |map|
  map.login       '/login', :conditions => {:method => :get}, :controller => 'authentication', :action => 'index'
  map.auth        '/login', :conditions => {:method => :post}, :controller => 'authentication', :action => 'login'
  map.logout      '/logout', :controller => 'authentication', :action => 'logout'
  map.login_help  '/login_help', :conditions => {:method => :get}, :controller => 'authentication', :action => 'help'
  map.active      '/active', :controller => 'authentication', :action => 'active'
  map.timeout     '/timeout', :controller => 'authentication', :action => 'logout'
  
  map.resources   :studies, :member => {:uploads => :get}
  map.resources   :involvements, :collection => {:upload => :post}
  map.resource    :search, :controller => :search
  map.resources   :reports
  map.hub         '/hub', {:controller => "admin", :action => "index"}
  map.default     '', {:controller => "studies", :action => "index"}
end

