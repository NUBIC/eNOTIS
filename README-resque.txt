==RESQUE
http://github.com/defunkt/resque
http://github.com/blog/542-introducing-resque

To install redis
  From source
    git clone git://github.com/antirez/redis.git
    cd redis
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

Then , open up 3 tabs in Terminal.app and type these commands (at RAILS_ROOT)
JOBS_PER_FORK=100 COUNT=3 QUEUES=redis_study_populator rake environment resque:workers
JOBS_PER_FORK=100 COUNT=3 QUEUES=redis_people_populator rake environment resque:workers
JOBS_PER_FORK=100 COUNT=1 QUEUES=redis_ldapper rake environment resque:workers