gem 'soap4r', '>=1.5.8'
require 'soap/wsdlDriver'

# Acts as a middle layer between the EirbServices module and the Eirb Webservice.
# Passes off queries to the eirb and returns queries
# Hides the true implementation of the return types from the soap driver factory

class EirbAdapter

  attr_reader :driver
  attr_reader :config
   
   def initialize(config = ServiceConfig.new)
     # creating the soap driver
     factory = SOAP::WSDLDriverFactory.new(config.url)
     @driver = factory.create_rpc_driver
     @session = nil
     @config = config
   end

   # Logs in to the eIRB webservice with the configuration settings
   # Configuration and driver building required before calling this method
   def login
      unless driver.nil?
       result= driver.login({:storeName => config.storename,
                     :userName => config.username,
                     :password => config.password})
       @session = result.loginResult
       return authenticated?
      else
        raise DataServiceError
      end
   end
 
   # We are authenticatd if there is a current session object
   def authenticated?
     !@session.nil?
   end

   # TODO add webservice logger 
   #
   # Calls the generated soap driver to perform the search on the remote resource
   # Accepts a param hash of values and converts hash parameters to formatted 
   # webservice parameters if needed
   def perform_search(params = {})
     unless authenticated?
       login
     end 
     params.merge!({:svcSessionToken => @session,
                   :parameters => self.class.format_search_parameters(params[:parameters])}) 
     search_results = driver.performSearch(params) #method that actually calls the soap service
     self.class.format_search_results(search_results)
   end

   # method for formatting hashes to eIRB params 
   def self.format_search_parameters(params)
     if params.is_a?(Hash)
       param_str = "" 
       params.each do |k,v|
         param_str += "<parameter name='#{k.to_s.upcase}' value='#{v}'/>" 
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

