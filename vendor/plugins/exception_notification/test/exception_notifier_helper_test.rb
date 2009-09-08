require 'test_helper'
require 'exception_notifier_helper'

class ExceptionNotifierHelperTest < Test::Unit::TestCase

  class ExceptionNotifierHelperIncludeTarget
    include ExceptionNotifierHelper
  end

  def setup
    @helper = ExceptionNotifierHelperIncludeTarget.new
  end

  # No controller
  
  def test_should_not_exclude_raw_post_parameters_if_no_controller
    assert !@helper.exclude_raw_post_parameters?
  end
  
  # Controller, no filtering
  
  class ControllerWithoutFilterParameters; end

  def test_should_not_filter_env_values_for_raw_post_data_keys_if_controller_can_not_filter_parameters
    stub_controller(ControllerWithoutFilterParameters.new)
    assert @helper.filter_sensitive_post_data_from_env("RAW_POST_DATA", "secret").include?("secret")
  end
  def test_should_not_exclude_raw_post_parameters_if_controller_can_not_filter_parameters
    stub_controller(ControllerWithoutFilterParameters.new)
    assert !@helper.exclude_raw_post_parameters?    
  end
  def test_should_return_params_if_controller_can_not_filter_parameters
    stub_controller(ControllerWithoutFilterParameters.new)
    assert_equal :params, @helper.filter_sensitive_post_data_parameters(:params)
  end

  # Controller with filtering

  class ControllerWithFilterParameters
    def filter_parameters(params)
      params[:password] = "[FILTERED]" if params.has_key?(:password)
      params.each{|key, value| value.merge!(:password => "[FILTERED]") if value.is_a?(Hash) and value.has_key?(:password)}
      # sometimes params values, e.g. the value for rack.request.form_hash, are hashes themselves and should be filtered.
      # this stubbed controller filters out :password from params and from params values that are hashes
    end
  end

  def test_should_filter_env_values_for_raw_post_data_keys_if_controller_can_filter_parameters
    stub_controller(ControllerWithFilterParameters.new)
    assert !@helper.filter_sensitive_post_data_from_env("RAW_POST_DATA", "secret").to_s.include?("secret")
    assert !@helper.filter_sensitive_post_data_from_env("rack.request.form_vars", "secret").to_s.include?("secret")
    assert !@helper.filter_sensitive_post_data_from_env(:password, "secret").to_s.include?("secret")
    assert @helper.filter_sensitive_post_data_from_env("SOME_OTHER_KEY", "secret").to_s.include?("secret")
  end
  def test_should_filter_hash_values_if_controller_can_filter_parameters
    stub_controller(ControllerWithFilterParameters.new)
    assert !@helper.filter_sensitive_post_data_from_env("rack.request.form_hash", {:password => "secret"}).to_s.include?("secret")
  end
  def test_should_exclude_raw_post_parameters_if_controller_can_filter_parameters
    stub_controller(ControllerWithFilterParameters.new)
    assert @helper.exclude_raw_post_parameters?
  end
  def test_should_delegate_param_filtering_to_controller_if_controller_can_filter_parameters
    stub_controller(ControllerWithFilterParameters.new)
    assert_equal({:foo => "bar"}, @helper.filter_sensitive_post_data_parameters({:foo => "bar"}))
  end
  
  private
    def stub_controller(controller)
      @helper.instance_variable_set(:@controller, controller)
    end
end