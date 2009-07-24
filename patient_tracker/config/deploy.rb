# developer machine will log in as enotis-deployer (ssh keys) to server (either enotis-staging or enotis.nubic.northwestern.edu)
# server will log in as build (ssh-keys) and check out code from code.nubic.northwestern.edu/git/enotis.git

set :application, "enotis"

# User
set :user, "enotis-deployer"
set :use_sudo, false

# Version control
default_run_options[:pty] = true # to get the passphrase prompt from git
set :scm, "git"
set :repository, "ssh://myo628@code.bioinformatics.northwestern.edu/git/enotis.git"
set :branch, "master"
set :deploy_to, "/var/www/apps/enotis"
set :deploy_via, :remote_cache

# Roles
task :set_roles do
  role :app, app_server
  role :web, app_server
  role :db, app_server, :primary => true
end

# Staging environment
desc "Deploy to staging"
task :staging do
  set :app_server, "enotis-staging.nubic.northwestern.edu"
  set :rails_env, "staging"
  set_roles
end

# Production environment
desc "Deploy to production"
task :production do
  set :app_server, "enotis.nubic.northwestern.edu"
  set :rails_env, "production"
  set_roles
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

# Inspiration
# http://github.com/guides/deploying-with-capistrano
# http://www.brynary.com/2008/8/3/our-git-deployment-workflow
# http://weblog.jamisbuck.org/2007/7/23/capistrano-multistage

# Gems
# http://henrik.nyh.se/2008/10/cap-gems-install-and-a-gem-dependency-gotcha
namespace :gems do
  desc "Install gems"
  task :install, :roles => :app do
    # always use sudo
    run "cd #{current_path}/patient_tracker && sudo rake RAILS_ENV=#{rails_env} gems:install"
  end
end

# Dynamic database.yml generation
# http://shanesbrain.net/2007/5/30/managing-database-yml-with-capistrano-2-0
# require 'erb'
# 
# set :db_user, "enotis"
# set :db_password, ""

# before "deploy:setup", :db
# after "deploy:update_code", "db:symlink" 
# 
# namespace :db do
#   desc "Create database yaml in shared path" 
#   task :default do
#     db_config = ERB.new <<-EOF
#     base: &base
#       adapter: oracle
#       username: #{db_user}
#       password: #{db_password}
# 
#     staging:
#       adapter: sqlite3
#       database: db/production.sqlite3
#       pool: 5
#       timeout: 5000
#     
#     production:
#       database: nubic_#{application}
#       <<: *base
#     EOF
# 
#     run "mkdir -p #{shared_path}/config" 
#     put db_config.result, "#{shared_path}/config/database.yml" 
#   end
# 
#   desc "Make symlink for database yaml" 
#   task :symlink do
#     run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
#   end
# end
