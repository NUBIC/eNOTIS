# Basics
gem "rails", "2.3.10"
gem "pg", '~> 0.9.0'
gem "haml", '3.1.2'
gem "rdiscount"
gem "compass", '0.10.6'
gem "capistrano", '~> 2.5.0'
gem "fastthread"
gem 'erubis'

# External services
gem "soap4r", '>=1.5.8'
gem "libxml-ruby", '>=1.1.3'
gem "daemons"
gem "aasm"
gem "couchrest"

# Import/export
gem "fastercsv", '>=1.5.0'
gem "paperclip", '2.1.2'
gem "ruport"
gem "acts_as_reportable"
gem "chronic", '>=0.2.3'
gem "factory_girl", '>=1.2.1'
gem "populator", '>=0.2.5'
gem "faker", '>=0.3.1'

# Auditing
gem "paper_trail", '>=1.1.1'
gem "view_trail", '>=0.3.1', :require => "view_trail"

# Search
gem "searchlogic"
gem 'will_paginate', '~> 2.3'

# Authentication
gem "bcdatabase", '~> 1.0.6'
gem "bcsec", '~>2.0'
gem "bcsec-rails", '~> 2.0'

# Authorization
gem "cancan"

gem "uuid"

# EMPI
gem "savon", "0.7.9"
gem "empi"

# irb magic
group :development do
  gem "wirble"
  gem "hirb"
end

#data capture
gem "surveyor", '0.20.0'

# # Debugging
# group :development do
#   gem "ruby-debug-base"
#   gem "ruby-debug"
# end

# Resque
gem 'SystemTimer'
gem 'redis' , '~> 2.0.0'
gem 'resque', '~> 1.10.0'
gem 'resque-jobs-per-fork', '~> 0.4.0'
gem 'resque-scheduler', '~> 1.9.0'

# Whenever
gem 'whenever', :require => false

# Testing
group :test, :cucumber, :hudson do
  gem 'rcov'
  gem 'cucumber', "0.8.4"
  gem "rspec", "~> 1.3.0"
  gem "rspec-rails", "~> 1.3.0"
  gem "resque_spec", '~> 0.2.0', :require => nil
  gem "cucumber-rails", "~> 0.3.0"
  gem "webrat", "~> 0.6.0"
  gem "database_cleaner", "~> 0.0"
  gem "activerecord-oracle_enhanced-adapter"
  gem "ruby-oci8"
end

gem "ci_reporter", "~> 1.6.0", :group => [:hudson]

source "http://download.bioinformatics.northwestern.edu/gems/"
source :rubygems
