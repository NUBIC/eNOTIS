module Webservices
  require 'logger'
  require 'webservices/edw_adapter'
  require 'webservices/edw'
  require 'webservices/edw_translations'
  require 'webservices/eirb_adapter'
  require 'webservices/eirb'
  require 'webservices/eirb_translations'
  
  def self.convert(values, converter, symbolized = true)
    results = []
    return values if values.nil?
    values.each do |val|
      result = {}
      val.each do |key, value|
        if symbolized
      	  result[converter[key.to_s].to_sym] = value if converter.has_key? key.to_s
      	else
      	  result[converter[key]] = value if converter.has_key? key
    	  end
      end
      results << result
    end
    return results
  end
end
class WebserviceConfig
  DEFAULTS = {} #YAML::load( File.open(File.dirname(__FILE__) + "/webservice-defaults.yml") ).freeze
  def initialize(values = {})
    unless values.is_a? Hash
      values = YAML::load( File.open(values) )
    end
    defaults_copy = nested_symbolize_keys!(deep_clone(DEFAULTS))
    values = nested_symbolize_keys!(deep_clone(values))
    @map = nested_merge_and_freeze!(defaults_copy, values)
  end

  def [](key)
    @map[key]
  end

  #######
  private

  def deep_clone(src)
    clone = { }
    src.each_pair do |k, v|
      clone[k] = v.is_a?(Hash) ? deep_clone(v) : v
    end
    clone
  end

  def nested_symbolize_keys!(target)
    target.keys.each do |k|
      v = target[k]
      nested_symbolize_keys!(v) if v.is_a?(Hash)
      target.delete(k)
      target[k.to_sym] = v
    end
    target
  end

  def nested_merge_and_freeze!(target, overrides)
    overrides.each_pair do |k, v|
      if v.is_a? Hash
        nested_merge_and_freeze!(target[k], overrides[k])
      else
        target[k] = v
      end
    end
    target.freeze
  end
end

class WebserviceError < RuntimeError
end

# Centralized logging for our webservice layer
class WebserviceLogger < Logger
  def initialize(location = File.join(RAILS_ROOT,"log/webservice_#{RAILS_ENV}.log"))
    super(location)
  end
  def format_message(severity, timestamp, progname, msg)
    "#{timestamp.to_s(:db)} #{severity} #{msg}\n" 
  end 
end
unless defined?(LOG)
  LOG = WebserviceLogger.new
end
