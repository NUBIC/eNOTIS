ActionController::Routing::Routes.draw do |map|


  map.with_options :controller=>'public_surveyor' do |p|
    p.public_available_surveys "public/surveys/",                                 :conditions => {:method=>:get},:action=>"index"                  
    p.take_public_survey       "public/surveys/:survey_code",                     :conditions => {:method => :get}, :action => "new"        # Only POST of survey to create
    p.create_my_public_survey  "public/surveys/:survey_code",                     :conditions => {:method => :post}, :action => "create"
    p.edit_my_public_survey    "public/surveys/:survey_code/take",                :conditions => {:method => :get}, :action => "edit"       # GET editable survey 
    p.update_my_public_survey  "public/surveys/:survey_code/:response_set_code",  :conditions => {:method => :put}, :action => "update"     # PUT edited survey 
    p.gi_diaries               "public/gi_survey",                                :conditions => {:method => :post}, :action => "gi_diaries"
  end
  
  map.login       '/login', :conditions => {:method => :get}, :controller => 'public', :action => 'index'
  map.login_help  '/login_help', :conditions => {:method => :get}, :controller => 'public', :action => 'login_help'
  map.help        '/help', :conditions => {:method => :get}, :controller => 'studies', :action => 'help'
  map.open_studies '/open_studies.:format', :conditions => {:method => :get}, :controller => 'public', :action => 'open_studies'
  map.study_involvements 'studies/:irb_number/involvements',{:controller => 'involvements',:action=>'index'}
  
  map.resources   :studies, :except => %w(delete destroy update),:member => {:charts => :get},:has_many=>[:uploads,:event_types]
  map.resources   :involvements, :collection => {:sample => :get, :empi_lookup => :get}, :member => {:other => :get,:forms=>:get},:has_many=>:events
  map.resource    :search, :controller => :search, :only => %w(show create)
  map.resources   :reports, :collection => {:nih => :get}, :except => %w(update destroy)
  map.resources   :roles, :only => :show
  map.hub         '/hub', {:controller => "admin", :action => "index"}
  map.pi_report   '/hub/pi_report', {:controller => "admin", :action => "pi_report"}
  map.default     '', {:controller => "studies", :action => "index"}
end

