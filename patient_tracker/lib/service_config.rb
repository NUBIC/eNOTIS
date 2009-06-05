# Service configuration wrapper class
# This class takes a yaml config file and for the
# current env wraps the yaml attrs as methods.
# It Should also work for hashes with similar structure.
# Assumes a Yaml file of the format:
#
# development:
#   key1: "xyz"
#   key2: 123
#   key3: "axj"
#
# ... etc ...


class ServiceConfig
  
  def initialize(env_name, options)
    @env = env_name
    @env_options = options[env_name.to_sym] ||  options[env_name.to_s]
  end

  def all
    if @env_options.respond_to?(:transform)
      @env_options.transform # converting yaml to a hash
    else
      @env_options # then its probably a hash
    end
  end

  # Maps the method call to the options obj using str or sym name
  def method_missing(m_name, *args)
    if @env_options[m_name.to_s] || @env_options[m_name] 
      obj = (@env_options[m_name.to_s] || @env_options[m_name])
      if obj.respond_to?(:value)
        obj.value
      else
        obj
      end
    else
      super.send(m_name, *args)
    end
  end

end
