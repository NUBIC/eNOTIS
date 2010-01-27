class Bcsec::CentralAuthenticationParameters
  DEFAULTS = YAML::load( File.open(File.dirname(__FILE__) + "/bcsec-defaults.yml") ).freeze

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
