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
default_run_options[:pty] = true # to get the passphrase prompt from git
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
end

# Install gems after deploy
after "deploy", "gems:install"

# Install the postgres gem after setup - it is needed for the rails initializer to run
after "deploy:setup", "gems:install_postgres"

# Gems
# http://henrik.nyh.se/2008/10/cap-gems-install-and-a-gem-dependency-gotcha
namespace :gems do
  desc "Install postgres gem - needed for the rails initializer to run - which happens before gem dependencies"
  task :install_postgres, :roles => :app do
    sudo "gem install postgres-pr"
  end
    
  desc "Install gems"
  task :install, :roles => :app do
    # always use sudo to rake gems
    # sudo helper string substitution per http://github.com/jamis/capistrano/commit/b45290e6ae3acce465ab5b7b8a82b7ad73a022e3
    run "cd #{current_path}/ && #{sudo} rake RAILS_ENV=#{rails_env} gems:install"

  end
  desc "Uninstall gems"
  task :cleanup, :roles => :app do
    gems_to_uninstall = %w(
      airblade-paper_trail
      bcdatabase
      bcsec
      binarylogic-searchlogic
      builder
      capistrano
      chriseppstein-compass
      chronic
      columnize
      composite_primary_keys
      cucumber
      diff-lcs
      faker
      fastercsv
      haml
      haml-edge
      highline
      hoe
      httpclient
      libxml-ruby
      linecache
      net-scp
      net-sftp
      net-ssh
      net-ssh-gateway
      nokogiri
      paperclip
      polyglot
      populator
      rcov
      rspec
      rspec-rails
      ruby-debug
      ruby-debug-base
      ruby-net-ldap
      rubytree
      session
      soap4r
      sqlite3-ruby
      stomp
      term-ansicolor
      thoughtbot-factory_girl
      treetop
      wddx
      webrat
      yoon-view_trail
      ZenTest
    )
    gems_to_uninstall.each do |gem_name|
      run "sudo gem uninstall --all --ignore-dependencies --executables #{gem_name}"
    end
  end
end

# Inspiration
# http://github.com/guides/deploying-with-capistrano
# http://www.brynary.com/2008/8/3/our-git-deployment-workflow
# http://weblog.jamisbuck.org/2007/7/23/capistrano-multistage


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
