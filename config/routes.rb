ActionController::Routing::Routes.draw do |map|
  map.login       '/login', :conditions => {:method => :get}, :controller => 'public', :action => 'index'
  map.login_help  '/login_help', :conditions => {:method => :get}, :controller => 'public', :action => 'login_help'
  map.help        '/help', :conditions => {:method => :get}, :controller => 'studies', :action => 'help'
  map.open_studies '/open_studies.:format', :conditions => {:method => :get}, :controller => 'public', :action => 'open_studies'
  map.study_involvements 'studies/:irb_number/involvements',{:controller => 'involvements',:action=>'index'}
  
  map.resources   :studies, :member => {:import => :get}, :except => %w(delete destroy edit update)
  map.resources   :involvements, :collection => {:upload => :post, :sample => :get, :empi_lookup => :get}, :member => {:other => :get}
  map.resource    :search, :controller => :search, :only => %w(show create)
  map.resources   :reports, :collection => {:nih => :get}, :except => %w(update destroy)
  map.resources   :services, :collection => {:services_update => :post}
  map.resources   :roles, :only => :show
  map.hub         '/hub', {:controller => "admin", :action => "index"}
  map.pi_report   '/hub/pi_report', {:controller => "admin", :action => "pi_report"}
  map.default     '', {:controller => "studies", :action => "index"}
end

