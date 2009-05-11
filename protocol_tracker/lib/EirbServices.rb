gem 'soap4r','>=1.5.8'
require 'soap/wsdlDriver'

module EirbServices
 
 EIRB_SEARCH_ACCESS = "http://riseirbsvr3.itcs.northwestern.edu/ClickXWebServices/DataManagement/SearchServices.asmx"
  
 #performSearchResult.searchResults.columnHeaders.columnHeader
 #performSearchResult.searchResults.resultSet.row

 self << class
   include Finder
 end

 module Finder
    
   def self.eirb_search(search_name, params)
      driver = SOAP::WSDLDriverFactory.new(EIRB_SEARCH_ACCESS+"?WSDL").create_rpc_driver
      result = driver.login({:storeName => "eIRB-Test", :userName => "blc615", :password => "nuc#1blc"})
      if result 
      answers = driver.performSearch({:svcSessionToken => result.loginResult,
                               :savedSearchName => search_name.to_s, 
                               :startRow => 1, 
                               :numRows => -1,
                               :expandMultiValueCells => false,
                               :parameters => convert_search_params(params) })

      end
   end
 
   def self.convert_search_params(params)
     # "<parameters><parameter name='ID' value='STU00000706'/></parameters>" 
     "<parameters>#{hash_to_xml(params)}</parameters>"  
   end

   # Method for converting hashes to eIRB specific parameter xml strings
   # Does deep parameter digging for nested hashes and flattens the params (as required by eIRB webservices)
   def self.hash_to_xml(h)
      params = ""
      h.keys.each do |key|
        if h[key].is_a?(Hash)
          params += self.has_to_xml(h[key])
        else
          params +="<parameter name='#{key}' value='#{value}' />"
        end
      end
      return params
   end
 end

end
