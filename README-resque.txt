==RESQUE
http://github.com/defunkt/resque
http://github.com/blog/542-introducing-resque

To install redis
  Homebrew
    brew install redis
  Macports
    sudo port install redis
  From source
    wget http://redis.googlecode.com/files/redis-1.2.5.tar.gz && tar zxvf redis-1.2.5.tar.gz 
    cd redis-1.2.5
    make
    sudo mv redis-server /usr/local/bin
    sudo mv redis-cli /usr/local/bin
    sudo mv redis-benchmark /usr/local/bin
To start redis
  cd RAILS_ROOT && redis-server config/redis.conf
To start workers 
  cd RAILS_ROOT && QUEUES=critical,high,medium,low rake environment resque:work
To start the sinatra app locally
  cd RAILS_ROOT && resque-web config/initializers/resque.rb