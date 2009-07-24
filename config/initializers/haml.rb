begin
  require File.join(File.dirname(__FILE__), 'lib', 'haml') # From here
rescue LoadError
  # don't choke if we haven't the gem, e.g. the first time we run rake gems:install
  # fixes no such file to load -- haml
  require 'haml' if defined? Haml # From gem
  # require 'haml' # From gem
end

# Load Haml and Sass

# don't choke if we haven't the gem, e.g. the first time we run rake gems:install
# fixes no such file to load -- haml
Haml.init_rails(binding) if defined? Haml