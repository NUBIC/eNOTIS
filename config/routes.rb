ActionController::Routing::Routes.draw do |map|
  map.login       '/login', :conditions => {:method => :get}, :controller => 'public', :action => 'index'
  map.login_help  '/login_help', :conditions => {:method => :get}, :controller => 'public', :action => 'help'
  map.study_involvements 'studies/:irb_number/involvements',{:controller => 'involvements',:action=>'index'}
  
  map.resources   :studies, :member => {:import => :get}, :except => %w(delete destroy edit update)
  map.resources   :involvements, :collection => {:upload => :post, :sample => :get}, :member => {:other => :get}
  map.resource    :search, :controller => :search, :only => %w(show create)
  map.resources   :reports, :collection => {:nih => :get}, :except => %w(update destroy)
  map.resources   :roles, :only => :show
  map.hub         '/hub', {:controller => "admin", :action => "index"}
  map.pi_report   '/hub/pi_report', {:controller => "admin", :action => "pi_report"}
  map.default     '', {:controller => "studies", :action => "index"}
end

