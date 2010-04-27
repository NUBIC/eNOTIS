require 'rubygems'
require 'http-access2' 
gem 'soap4r', '>=1.5.8'
require 'soap/wsdlDriver'

 EIRB_SEARCH_ACCESS = "http://riseirbsvr3.itcs.northwestern.edu/ClickXWebServices/DataManagement/SearchServices.asmx"
 EIRB_ENTITY_ACCESS = "http://riseirbsvr3.itcs.northwestern.edu/ClickXWebServices/EntityManager/EntityServices.asmx"
   
 client = HTTPAccess2::Client.new()  
 #client.ssl_config.set_client_cert_file('certs/client.cer', 'certs/client.key')  
 #client.ssl_config.set_trust_ca('certs/ca.cer')  
 #client.set_basic_auth(EIRB_SEARCH_ACCESS, 'blc615', 'nuc#1blc')  
 begin
   puts "Able to access eIRB search url" unless client.get(EIRB_SEARCH_ACCESS).content == nil 
 rescue
   puts "Not able to access search url because:\r\n #{$!}"
 end

 begin
   puts "Able to acesss eIRB entity url" unless client.get(EIRB_ENTITY_ACCESS).content == nil
 rescue
   puts "Not able to access entity url because:\r\n #{$!}"
 end

# testing soap4r connectivity 
driver = SOAP::WSDLDriverFactory.new(EIRB_SEARCH_ACCESS+"?WSDL").create_rpc_driver
result = driver.login({:storeName => "eIRB-Test", :userName => "blc615", :password => "nuc#1blc"})
answers = driver.performSearch({:svcSessionToken => result.loginResult,
                               :savedSearchName => "idStatus", 
                               :startRow => 1, 
                               :numRows => -1,
                               :expandMultiValueCells => false,
                               :parameters => "<parameters><parameter name='ID' value='STU00000706'/></parameters>"})
puts answers.performSearchResult.searchResults.columnHeaders.columnHeader.inspect
puts answers.performSearchResult.searchResults.resultSet.row.value.inspect
#answers.performSearchResult.searchResults.columnHeaders.columnHeader #=> gets column headers

#answers = driver.performSearch({:svcSessionToken => result.loginResult,
#                               :savedSearchName => "eNOTIS find_by_study_id", 
#                               :startRow => 1, 
#                               :numRows => -1,
#                               :expandMultiValueCells => false,
#                               :parameters => "<parameters><parameter name='ID' value='STU00000706'/></parameters>"})
#
#answers = driver.performSearch({:svcSessionToken => result.loginResult,
#:parameters=>"<parameters><parameter name='ID' value='STU00002629'/></parameters>",
#:startRow=>1,
#:numRows=>500,
#:expandMultiValueCells=>false,
#:savedSearchName=>"eNOTIS Study Access"}
#                              )
