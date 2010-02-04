# Basics
gem "rails", "2.3.4"
gem "pg"
gem "haml", '>=2.2.0'
gem "chriseppstein-compass", '>=0.8.13'
gem "capistrano", '>=2.5.8'
gem "fastthread"

# External services
gem "soap4r", '>=1.5.8'
gem "libxml-ruby", '>=1.1.3'
gem "stomp", '>=1.1'
gem "activemessaging"
gem "aasm"

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
gem "airblade-paper_trail", '>=1.1.1'
gem "yoon-view_trail", '>=0.3.1', :require_as => "view_trail"

# Search
gem "binarylogic-searchlogic"

# Authentication
gem "bcdatabase", '<1.0.0'
gem "bcsec"

# Testing
only :test, :cucumber, :hudson do
  gem "rspec", "~> 1.2.0"
  gem "rspec-rails", "~> 1.2.0"
  gem "cucumber-rails", "~> 0.2.0"
  gem "webrat", "~> 0.6.0"
  gem "database_cleaner", "~> 0.0"
end
gem "ruby-debug-base", '>=0.10.3', :only => [:development]
gem "ruby-debug", '>=0.10.3',      :only => [:development]

gem "ci_reporter", "~> 1.6.0", :only => [:hudson]

source "http://download.bioinformatics.northwestern.edu/gems/"

bundle_path "vendor/bundler_gems" # The default is: vendor/gems
# bin_path "bin"

disable_system_gems
