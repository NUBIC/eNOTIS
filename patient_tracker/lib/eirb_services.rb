gem 'soap4r', '>=1.5.8'
require 'soap/wsdlDriver'

module EirbServices

  class Server

     SEARCH_DEFAULTS = {:startRow => 1, 
                        :numRows => -1,
                        :expandMultiValueCells => false}.freeze

     attr_accessor :connection_url, :username, :password, :storename, :session, :driver

     def configure(params)
       @connection_url = params[:url]
       @username = params[:username]
       @password = params[:password]
       @storename = params[:storename]
       @session = nil
       @driver = nil
     end
 
     # Creates the soap driver for us using our configuration settings
     def create_driver
       factory = SOAP::WSDLDriverFactory.new(@connection_url)
       @driver = factory.create_rpc_driver
     end
    
     # Logs in to the eIRB webserivce with the configuration settings
     # Configuration and driver building required before calling this method
     def login
        unless @driver.nil?
         @session= @driver.login({:storeName => @storename,
                       :userName => @username,
                       :password => @password})
         return authenticated?
        else
          raise DataServiceError
        end
     end
   
     # We are authenticatd if there is a current session object
     def authenticated?
       !@session.nil?
     end
    
     # ==== Custom search wrappers for pre-defined eIRB system queries ====
     
     # Performs a query to get the study status using the study ID 
     def find_status_by_id(study_id)
       # merging in the defaults, overwritting ones we need to
       search_settings = SEARCH_DEFAULTS.merge({:savedSearchName => "idStatus",
                                               :parameters => {:id => study_id}})
       search_results = perform_search(search_settings)  
     end
     

     # ==== Wrapper methods for calling soap services and formatting parameters ====
    
     # Calls the generated soap driver to perform the search on the remote resource
     # Accepts a param hash of values and converts hash parameters to formatted 
     # webservice parameters if needed
     def perform_search(params = {})
       unless @session.nil?
       params.merge!({:svcSessionToken => @session,
                     :parameters => Server.format_search_parameters(params[:parameters])})
       @driver.performSearch(params)
       else
         raise DataServiceError
       end
     end

     # Class method for formatting hashes to eIRB params 
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
  end

  class DataServiceError < RuntimeError 
      
  end

end
