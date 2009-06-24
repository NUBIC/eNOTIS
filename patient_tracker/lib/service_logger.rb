# Centralized logging for our webservice layer
 
require 'logger'

class ServiceLogger < Logger
  # setting up some reasonable defaults based on the 
  # fact that this will be run in a Rails app
  def initialize(location=File.join(RAILS_ROOT,"log/#{RAILS_ENV}_webservice.log"))
    super(location)
  end
end

unless defined?(WSLOGGER)
  WSLOGGER = ServiceLogger.new
end
