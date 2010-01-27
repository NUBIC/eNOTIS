require 'soap/wsdlDriver'

# Adapter between the Eirb class and the eIRB webservice. Hides the true implementation of the return types from the soap driver factory
class EirbAdapter

  attr_accessor :driver
  attr_accessor :config
  attr_accessor :session
  
  def initialize
    self.config ||= WebserviceConfig.new("/etc/nubic/eirb-#{RAILS_ENV.downcase}.yml")
    # creating the soap driver
    begin
      LOG.info("[EirbAdapter] SOAP factory init:  #{config[:url]}")
      factory = SOAP::WSDLDriverFactory.new(config[:url])
      self.driver = factory.create_rpc_driver
      self.session = nil
      driver.options['protocol.http.receive_timeout'] = config[:timeout].to_i
      driver.options['protocol.http.connect_timeout'] = config[:timeout].to_i
      driver.options['protocol.http.send_timeout']    = config[:timeout].to_i
    rescue => error
      WebserviceError.new(error.message)
    end
  end

  # Logs in to the eIRB webservice with the configuration settings
  # Configuration and driver building required before calling this method
  def login
    unless driver.nil?
      result = driver.login({:storeName => config[:storename], :userName => config[:username], :password => config[:password]})
      self.session = result.loginResult
      LOG.info("[EirbAdapter] SOAP factory login: #{config[:storename]}, result: #{@session.inspect}")
      return authenticated?
    else
      raise WebserviceError.new("Login Failed")
    end
  end

  # We are authenticatd if there is a current session object
  def authenticated?
    !session.nil?
  end

  #
  # Calls the generated soap driver to perform the search on the remote resource
  # Accepts a param hash of values and converts hash parameters to formatted 
  # webservice parameters if needed
  def perform_search(params = {})
    begin
      login unless authenticated?
      params.merge!({:svcSessionToken => @session, :parameters => self.class.format_search_parameters(params[:parameters])})
      LOG.info("#{Time.now} [EirbAdapter] search:  #{params.inspect}")
      search_results = driver.performSearch(params) # method that actually calls the soap service
      LOG.info("#{Time.now} [EirbAdapter] results: #{(search_results.performSearchResult.searchResults.respond_to?(:row) and search_results.performSearchResult.searchResults.row.is_a?(Array)) ? search_results.performSearchResult.searchResults.row.size : search_results.inspect}")
      # LOG.debug("#{Time.now} [EirbAdapter] results: #{search_results.inspect}")
      return self.class.format_search_results(search_results)
    rescue => bang
      raise WebserviceError.new(bang.message)
    end
  end

  # method for formatting hashes to eIRB params 
  def self.format_search_parameters(params)
    if params.is_a?(Hash)
      param_str = "" 
      params.each do |k,v|
        param_str += "<parameter name='#{k.to_s}' value='#{v}'/>" 
      end 
      return "<parameters>#{param_str}</parameters>"
    else
      return params
    end
  end

  # Takes the nasty results and converts them to keyed values
  def self.format_search_results(results)
    mapped = [] 
    c_h = results.performSearchResult.searchResults.columnHeaders.columnHeader
    r_set = results.performSearchResult.searchResults.resultSet
    if r_set.respond_to?(:row) 
      result_rows = r_set.row
      if result_rows.is_a?(Array) #holding multiple values
        result_rows.each do |row_obj|
          t_hash = make_hash(row_obj.value,c_h)
          mapped << t_hash unless t_hash.empty?
        end
      else  
        t_hash = make_hash(result_rows.value,c_h)
        mapped << t_hash unless t_hash.empty?
      end
    end
    LOG.info("#{Time.now} [EirbAdapter] mapped:  #{mapped.size}")
    # LOG.debug("#{Time.now} [EirbAdapter] mapped: #{mapped.inspect}")
    mapped
  end

  # creating an array of single hashes (key values) to return
  def self.make_hash(values,keys)
    tmp = {}
    values.each_with_index do |val,idx|
      tmp.merge!({ keys[idx] => val })
    end
    tmp
  end
end

