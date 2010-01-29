require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../soap_mock_helper')

describe EirbAdapter do

  before(:each) do
    WebserviceConfig.stub!(:new).and_return({})
    factory = Object.new
    factory.stub!(:create_rpc_driver).and_return(Object.new)
    SOAP::WSDLDriverFactory.stub!(:new).and_return(factory)
    @adapter = EirbAdapter.new
  end

  describe "with valid login credentials" do

    before(:each) do
      @driver = mock(SOAP::WSDLDriver)
      @login = Object.new
      @login.stub!(:loginResult).and_return(Object.new)
      @driver.stub!(:login).and_return(@login)
      @adapter.stub!(:driver).and_return(@driver)
    end  
      
    it "calls the soap driver with login credentials" do
      @adapter.login.should be_true  
    end

    it "knows if it is authenticated if their is a session" do
      @adapter.authenticated?.should be_false
      @adapter.login
      @adapter.authenticated?.should be_true
    end

    describe "performing a search with the active session" do
      before(:each) do
        @adapter.stub!(:authenticated?).and_return(true)
      end

      it "can perform a search" do
        @driver.should_receive(:performSearch).and_return(SoapMockHelper::Search.new.results([]))
        @adapter.perform_search({:blah => "foo"}).should_not be_nil 
      end

      it "calls the driver to perform a search" do
        search_params = {:svcSessionToken => @result, :savedSearchName => "idStatus",
          :startRow => 1, :numRows => -1, :expandMultiValueCells => false,
          :parameters => "<parameters><parameter name='ID' value='STU00000706'/></parameters>"}
        @driver.should_receive(:performSearch).with(search_params).and_return(SoapMockHelper::Search.new.results([]))
        @adapter.perform_search({:savedSearchName => "idStatus", :startRow =>1, :numRows =>-1,
                               :expandMultiValueCells => false,
                               :parameters => "<parameters><parameter name='ID' value='STU00000706'/></parameters>"})
      end
      
    end

    describe "performing a search with an inactive session" do
      it "attempts to login using the config settings" do
        @adapter.should_receive(:login)
        @driver.should_receive(:performSearch).and_return(SoapMockHelper::Search.new.results([]))
        @adapter.perform_search({:blah => "foo"}).should_not be_nil 
      end
    end
  end 
   

  describe "working with an invalid session login" do
    it "should return authenticated? as false" do
      @adapter.authenticated?.should be_false   
    end
  end
   
  describe "class methods" do
    it "can convert a hash to search parameter format of the eirb service" do
      test_params = {:ID => "STU100"}
      final_params = "<parameters><parameter name='ID' value='STU100'/></parameters>"
      EirbAdapter.format_search_parameters(test_params).should == final_params 
      test_params = { :BLAH => 123}
      final_params = "<parameters><parameter name='BLAH' value='123'/></parameters>"    
      EirbAdapter.format_search_parameters(test_params).should == final_params 
      test_params = {:foo => 3.14159265}
      final_params = "<parameters><parameter name='foo' value='3.14159265'/></parameters>"
      EirbAdapter.format_search_parameters(test_params).should == final_params 
    end
    
    it "can convert returned soap results to a hash" do
      payload = [{"ID" => "STU0000123415"}, {"status" => "Approved"}]
      result =  SoapMockHelper::Search.new.results(payload)
      mapped = EirbAdapter.format_search_results(result)
      mapped.first["ID"].should == payload.first["ID"]
      mapped.first["status"].should == payload.second["status"]
    end

    it "can return soap results as an array of hashes" do
      
      payload = [[{"ID" => "STU0000123415"}, {"status" => "Approved"}], [{"ID" => "STU123123"},{"status" => "Terminated"}]]
      result =  SoapMockHelper::Search.new.results(payload)
      mapped = EirbAdapter.format_search_results(result)
      mapped.should == [{"ID" => "STU0000123415", "status" => "Approved"}, {"ID" => "STU123123","status" => "Terminated"}]

    end
  end
end
