# Basics
gem "rails", "2.3.5"
gem "pg", '~> 0.9.0'
gem "haml", '~> 2.2.0'
gem "rdiscount"
gem "compass", '~> 0.8.0'
gem "capistrano", '~> 2.5.0'
gem "fastthread"

# External services
gem "soap4r", '>=1.5.8'
gem "libxml-ruby", '>=1.1.3'
gem "stomp", '>=1.1'
gem "activemessaging"
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

# Authentication
gem "bcdatabase"#, '<1.0.0'
gem "bcsec"

# irb magic
group :development do
  gem "wirble"
  gem "hirb"
end

# Resque
gem 'redis' , '0.2.0'
gem 'resque', '~>1.6.1'

# Testing
group :test, :cucumber, :hudson do
  gem "rspec", "~> 1.2.0"
  gem "rspec-rails", "~> 1.2.0"
  gem "cucumber-rails", "~> 0.3.0"
  gem "webrat", "~> 0.6.0"
  gem "database_cleaner", "~> 0.0"
end

gem "ruby-debug-base", '>=0.10.3', :group => [:development]
gem "ruby-debug", '>=0.10.3',      :group => [:development]
gem "ci_reporter", "~> 1.6.0", :group => [:hudson]

source "http://download.bioinformatics.northwestern.edu/gems/"
source :rubygems