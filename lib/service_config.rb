# Service configuration wrapper class
# This class takes a yaml config file and for the current env wraps the yaml attrs as methods.
# It Should also work for hashes with similar structure. Assumes a Yaml file of the format:
#
# development:
#   key1: "xyz"
#   key2: 123
#   key3: "axj"
# ... etc ...

class ServiceConfig
  def initialize(env_name, options)
    opts = options.is_a?(YAML::Syck::Node) && options.respond_to?(:transform) ? options.transform : options # yaml transformed to hash, or just the hash
    @options = HashWithIndifferentAccess.new(opts)[env_name] or raise "could not load options for #{env_name}"
  end
  def all
    return @options
  end
  def method_missing(m_name, *args)
    return super unless (obj = @options[m_name])
    obj.respond_to?(:value) ? obj.value : obj
  end
end
