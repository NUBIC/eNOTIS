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

# for bundler
require 'bundler/capistrano'

set :application, "enotis"

# User
#set :user, "enotis-deployer"
set :use_sudo, false
ssh_options[:forward_agent] = true

# Version control
default_run_options[:pty]   = true # to get the passphrase prompt from git

# System Path -- ensure that any capistrano command knows about Ruby Enterprise Edition.
# Caveat: Assumes we're using CENTOS with Kerberos
# ensure that oci8 gem can be built
default_environment['ORACLE_HOME'] = '/usr/lib/oracle/11.2/client64'
default_environment['LD_LIBRARY_PATH'] = '/usr/lib/oracle/11.2/client64/lib:/lib:/usr/lib64:/usr/lib:/usr/local/lib'
default_environment['PATH'] = '/usr/lib/oracle/11.2/client64/bin:/opt/ruby-enterprise/bin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin'

set :scm, "git"
set :repository, "ssh://code.bioinformatics.northwestern.edu/git/enotis.git"
set :branch do
  # http://nathanhoad.net/deploy-from-a-git-tag-with-capistrano
  puts
  puts "Tags: " + `git tag`.split("\n").join(", ")
  puts "Remember to push tags first: git push origin --tags"
  ref = Capistrano::CLI.ui.ask "Tag, branch, or commit to deploy [master]: "
  ref.empty? ? "master" : ref
end
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
  set :whenever_environment, fetch(:rails_env)
  set_roles
end

# Production environment
desc "Deploy to production"
task :production do
  set :app_server, "enotis.nubic.northwestern.edu"
  set :rails_env, "production"
  set :whenever_environment, fetch(:rails_env)
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
    sudo "chmod -R g+w #{shared_path} #{current_path} #{release_path}"
  end
end

# Administration tasks
namespace :admin do
  desc "Creates admins via rake db:populate:admins"
  task :create_admins, :roles => :app do
    run "cd #{current_path} && rake RAILS_ENV=#{rails_env} db:populate:admins"
  end
end

# backup the database before migrating
before 'deploy:migrate', 'db:backup'

# after deploying, generate static pages, copy over uploads and results, cleanup old deploys, aggressively set permissions
after 'deploy:update_code', 'web:static', 'web:uploads_and_results', 'deploy:cleanup'

# the static maintenance page has to be generated before it can be displayed
before 'web:disable', 'web:static'

# restart the app after hiding the static maintenance page
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
    run "mv #{current_path}/public/index_coming_soon.html #{current_path}/public/maintenance.html"

    # More Info: http://www.shiftcommathree.com/articles/make-your-rails-maintenance-page-respond-with-a-503
    # Add the following to the enotis apache configuration:

    # ErrorDocument 503 /maintenance.html
    # RewriteEngine On
    #
    # # rewrites nearly everything to /maintenance, forcing redirect
    # RewriteCond %{REQUEST_URI} !\.(js|css|gif|jpg|png|mov|swf)$
    # RewriteCond %{DOCUMENT_ROOT}/maintenance.html -f
    # RewriteCond %{SCRIPT_FILENAME} !maintenance.html|policy.html|maintenance$
    # RewriteRule ^.*$  /maintenance [R]
    #
    # # rewrites /maintenance to error 503, maintenance.html, no redirect
    # RewriteRule ^/maintenance$ - [R=503,L]
  end

  desc "Hide static maintenance page"
  task :enable, :roles => :web, :except => { :no_release => true } do
    run "rm -f #{current_path}/public/maintenance.html"
  end

  desc "Link upload/result files"
  task :uploads_and_results, :roles => :web, :except => {:no_release => true} do
    run "mkdir -p #{shared_path}/uploads #{shared_path}/results"
    run "ln -fs #{shared_path}/uploads #{latest_release}/public/uploads"
    run "ln -fs #{shared_path}/results #{latest_release}/public/results"
  end
end

# Database
namespace :db do
  desc "Backup Database"
  task :backup,  :roles => :app do
    run "cd #{current_path} && rake RAILS_ENV=#{rails_env} db:backup"
  end
end

#require "whenever/capistrano"
#set(:whenever_command, "bundle exec whenever")

# Inspiration
# http://github.com/guides/deploying-with-capistrano
# http://www.brynary.com/2008/8/3/our-git-deployment-workflow
# http://weblog.jamisbuck.org/2007/7/23/capistrano-multistage
# http://github.com/wycats/bundler
