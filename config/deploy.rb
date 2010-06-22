# developer machine will log in with netid to server (either enotis-staging or enotis.nubic.northwestern.edu)
# developer machine will also log in with netid to code.nubic.northwestern.edu to do a git ls-remote to resolve branch/tag to commit hash
# server will log in with the same netid and check out from code.nubic.northwestern.edu/git/enotis.git

# add the following lines to your ~/.ssh/config, replacing xyz123 with your netid
# Host enotis-staging*
# Hostname enotis-staging.nubic.northwestern.edu
# User xyz123
# 
# Host code*
# Hostname code.bioinformatics.northwestern.edu
# User xyz123

set :application, "enotis"

# User
# set :user, "enotis-deployer"
set :use_sudo, false
ssh_options[:forward_agent] = true

# Version control
default_run_options[:pty]   = true # to get the passphrase prompt from git

# System Path -- ensure that any capistrano command knows about Ruby Enterprise Edition. 
# Caveat: Assumes we're using CENTOS with Kerberos
default_environment['PATH'] = "/opt/ruby-enterprise/bin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin"

set :scm, "git"
set :repository, "ssh://code.bioinformatics.northwestern.edu/git/enotis.git"

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
  desc "Fix permissions"
  task :permissions do
    sudo "chmod -R g+w #{shared_path} #{current_path}"
  end
end

namespace :resque do
  desc "Requeue Failed Jobs"
  task :requeue, :roles => :app  do
    run "cd #{current_path} && rake RAILS_ENV=#{rails_env} redis:resque:requeue"
  end
  desc "Restart workers"
  task :restart, :roles => :app do
    %w(people study).each do |worker_type|
      1.upto(2) do |num|
        sudo "cd #{shared_path}/pids && kill -QUIT `cat resque_#{worker_type}_#{num}.pid`"
      end
    end
  end
  desc "Pause workers"
  task :pause,:roles => :app  do
    %w(people study).each do |worker_type|
      1.upto(2) do |num|
        sudo "cd #{shared_path}/pids && kill -USR2 `cat resque_#{worker_type}_#{num}.pid`"
      end
    end
  end
  desc "Resume workers"
  task :resume, :roles => :app  do
    %w(people study).each do |worker_type|
      1.upto(2) do |num|
        sudo "cd #{shared_path}/pids && kill -CONT `cat resque_#{worker_type}_#{num}.pid`"
      end
    end
  end
  desc "Kill workers"
  task :kill , :roles => :app do
    %w(people study).each do |worker_type|
      1.upto(2) do |num|
        sudo "cd #{shared_path}/pids && kill -TERM `cat resque_#{worker_type}_#{num}.pid`"
      end
    end
  end
end

# Administration tasks
namespace :admin do
  desc "Creates admins via rake db:populate:admins"
  task :create_admins, :roles => :app do
    run "cd #{current_path} && rake RAILS_ENV=#{rails_env} db:populate:admins"  
  end
  
  namespace :poller do
    [:start, :stop, :restart].each do |t|
      desc "#{t.to_s.capitalize}s poller"
      task t, :roles => :app do
        run "cd #{current_path} && RAILS_ENV=#{rails_env} script/poller #{t.to_s}"
      end
    end
  end
  
  desc "Imports from redis"
  task :import_from_redis, :roles => :app do
    run "cd #{current_path} && rake RAILS_ENV=#{rails_env} redis"
  end
end

# Bcdatabase
namespace :bcdatabase do
  desc "Copies files from local:/etc/nubic/db to remote:/etc/nubic/db"
  task :copy do
    run "mkdir -p #{shared_path}/nubic/db"
    upload "/etc/nubic/db", "#{shared_path}/nubic/db", :via => :scp, :recursive => true
    sudo "mv #{shared_path}/nubic/db/* /etc/nubic/db"
    run "rm -r #{shared_path}/nubic"
  end
end

# Bundler
namespace :bundler do
  desc "check_paths"
  task :check_paths, :roles => :app do
    run "echo $PATH"
  end
  desc "Create, clear, symlink the shared bundler_gems path and install Bundler cached gems"
  task :install, :roles => :app do
    run "mkdir -p #{shared_path}/bundle"
    run "cd #{release_path} && bundle install #{shared_path}/bundle"
  end
end

after 'deploy:update_code', 'bundler:install', 'web:static', 'web:uploads_and_results', 'deploy:cleanup', 'deploy:permissions', 'resque:restart'

before 'web:disable', 'web:static'
after 'web:enable', 'deploy:restart'

# Maintenance
namespace :web do
  desc "Enable static pages"
  task :static, :roles => :web, :except => { :no_release => true } do
    run "cp #{latest_release}/static/site/*.html #{latest_release}/public/"
  end
  
  desc "Display static maintenance page"
  task :disable, :roles => :web, :except => { :no_release => true } do
    on_rollback { run "rm -f #{current_path}/public/index.html" }
    run "mv #{current_path}/public/index_coming_soon.html #{current_path}/public/index.html"
  end
  
  desc "Hide static maintenance page"
  task :enable, :roles => :web, :except => { :no_release => true } do
    run "rm -f #{current_path}/public/index.html"
  end
  
  desc "Link upload/result files"
  task :uploads_and_results, :roles => :web, :except => {:no_release => true} do
    run "mkdir -p #{shared_path}/uploads #{shared_path}/results"
    run "ln -fs #{shared_path}/uploads #{latest_release}/public/uploads"
    run "ln -fs #{shared_path}/results #{latest_release}/public/results"
  end
end

# Inspiration
# http://github.com/guides/deploying-with-capistrano
# http://www.brynary.com/2008/8/3/our-git-deployment-workflow
# http://weblog.jamisbuck.org/2007/7/23/capistrano-multistage
# http://github.com/wycats/bundler