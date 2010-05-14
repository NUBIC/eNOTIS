==RESQUE
http://github.com/defunkt/resque
http://github.com/blog/542-introducing-resque

To install redis
  From source
    git clone git://github.com/antirez/redis.git
    cd redis
    git checkout v1.3.10
    make 32bit
    sudo mv redis-server /usr/local/bin
    sudo mv redis-cli /usr/local/bin
    sudo mv redis-benchmark /usr/local/bin
To start redis
  cd RAILS_ROOT && redis-server config/redis.conf
To start workers 
  cd RAILS_ROOT && JOBS_PER_WORKER=100 COUNT=4 QUEUES=<any queue> rake environment resque:workers
To start the sinatra app locally
  cd RAILS_ROOT && resque-web config/initializers/resque.rb

To start the nightly importing process
First, setup an SSH Tunnel (if your'e running this at your desk)
sudo ssh -f -N -L 636:directory.northwestern.edu:636 sjg304@enotis-staging.nubic.northwestern.edu

For the mass importing: 
Then , open up 4 tabs in Terminal.app and type these commands (at RAILS_ROOT)
rake eirb:redis_import:full
JOBS_PER_FORK=25 COUNT=3 QUEUES=redis_study_populator rake environment resque:workers
JOBS_PER_FORK=25 COUNT=3 QUEUES=redis_authorized_personnel_populator,redis_ldapper,redis_bogus_netid rake environment resque:workers

For the Nightly Work
rake eirb:redis_import:nightly
JOBS_PER_FORK=25 COUNT=3 QUEUES=redis_study_populator rake environment resque:workers
JOBS_PER_FORK=25 COUNT=3 QUEUES=redis_authorized_personnel_populator,redis_ldapper,redis_bogus_netid rake environment resque:workers

For checking on resque progress on staging setup an SSH tunnel on staging and change the resque and redis config locally
ssh -f -N -L 6380:q-staging.nubic.northwestern.edu:6379 sjg304@enotis-staging.nubic.northwestern.edu

To view resque jobs locally simply go to /admin/jobs and type in the username and password enotis_jobs