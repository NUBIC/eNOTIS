# http://github.com/guides/deploying-with-capistrano
# http://www.brynary.com/2008/8/3/our-git-deployment-workflow
# http://weblog.jamisbuck.org/2007/7/23/capistrano-multistage

set :application, "enotis"

# Version control
default_run_options[:pty] = true # to get the passphrase prompt from git
set :scm, "git"
set :repository,  "git@github.com:breakpointer/enotis.git"
set :branch, "master"
set :deploy_to, "/var/www/apps/enotis"
set :deploy_via, :remote_cache

# User
set :user, "enotis-deployer"

# Roles
task :set_roles do
  role :app, app_server
  role :web, app_server
  role :db, app_server, :primary => true
end

# Deploy start/stop/restart
namespace :deploy do
  desc "Restarting passenger with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

# Staging
desc "deploy to staging"
task :staging do
  set :app_server, "enotis-staging.nubic.northwestern.edu"
  set_roles
end

# Production
desc "deploy to production"
task :production do
  set :app_server, "enotis.nubic.northwestern.edu"
  set_roles
end