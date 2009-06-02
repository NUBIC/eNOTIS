require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../soap_mock_helper')

describe EirbAdapter do

   before(:each) do
    config = Object.new
    config.stub!(:url).and_return("http://blah.com")
    config.stub!(:username).and_return("foo")
    config.stub!(:password).and_return("bar")
    config.stub!(:storename).and_return("eirb")
    @adapter = SoapAdapter.new(config)
     
  end

  describe "with valid login credentials" do

    before(:each) do
      @adapter.stub!(:session).and_return(Object.new) 
    end  
      
    it "calls the soap driver with login credentials" do
      @adapter.login.should be_true  
    end

    it "sets the session if the login was sucessfull" do
      @adapter.session.should be_nil
      @adapter.login.should be_true
      @adapter.session.should_not be_nil
    end

    it "knows if it is authenticated if their is a session" do
      @adapter.authenticated?.should be_false
      @adapter.login
      @adapter.authenticated?.should be_true
    end

    describe "performing a search with the active session" do

      before(:each) do
        @adapter.login
      end

      it "can perform a search" do
        @driver.should_receive(:performSearch).and_return([])
        @adapter.perform_search({:blah => "foo"}).should_not be_nil 
      end

      it "calls the driver to perform a search" do
        search_params = {:svcSessionToken => @result, :savedSearchName => "idStatus",
          :startRow => 1, :numRows => -1, :expandMultiValueCells => false,
          :parameters => "<parameters><parameter name='ID' value='STU00000706'/></parameters>"}
        @driver.should_receive(:performSearch).with(search_params).and_return([])
        @adapter.perform_search({:savedSearchName => "idStatus", :startRow =>1, :numRows =>-1,
                               :expandMultiValueCells => false,
                               :parameters => "<parameters><parameter name='ID' value='STU00000706'/></parameters>"})
      end

      it "has wrapper search for idStatus" do
        id_search_params = {:svcSessionToken => @result, :savedSearchName => "idStatus",
          :startRow => 1, :numRows => -1, :expandMultiValueCells => false,
          :parameters => "<parameters><parameter name='ID' value='STU00000706'/></parameters>"}
       
        @driver.should_receive(:performSearch).with(id_search_params).and_return(SoapMockHelper::Search.new.results([]))
        
        @adapter.find_status_by_id("STU00000706")
      end
      
      describe "search results" do
        it "returns an empty array for a search with no results" do
         empty_search = SoapMockHelper::Search.new.results([])
         @driver.should_receive(:performSearch).and_return(empty_search)
         @adapter.find_status_by_id("STU123123123").should == []
        end
        
        it "returns the results as a hash for one row results" do
          payload = [{"ID" => "STU0912301239"}, {"Project State.ID" => "APPROVED"}, {"Name" => "The research study"}, {"Research Type.ID" => "INTERVENTIONAL"}]
          results = SoapMockHelper::Search.new.results(payload)
          @driver.should_receive(:performSearch).and_return(results)
          @adapter.find_status_by_id("STU123123123").should == [{"ID" => "STU0912301239", "Project State.ID" => "APPROVED", "Name" => "The research study", "Research Type.ID" => "INTERVENTIONAL"}]
        end
          
        it "returns the results as an array of hashes for multi-row results" do
          payload = [[{"ID" => "STU0912301239"}, {"Project State.ID" => "APPROVED"}, {"Name" => "The research study"}, {"Research Type.ID" => "INTERVENTIONAL"}],
            [{"ID" => "STU01239"}, {"Project State.ID" => "Terminated"}, {"Name" => "The other research study"}, {"Research Type.ID" => "INTERVENTIONAL"}]]
          results = SoapMockHelper::Search.new.results(payload)
          @driver.should_receive(:performSearch).and_return(results)
          # it doesnt matter that this particular method will never return 
          # multiple values. We are just testing the end to end process.
          @adapter.find_status_by_id("STU123123123").should == [{"ID" => "STU0912301239", "Project State.ID" => "APPROVED", "Name" => "The research study", "Research Type.ID" => "INTERVENTIONAL"},
            {"ID" => "STU01239", "Project State.ID" => "Terminated", "Name" => "The other research study", "Research Type.ID" => "INTERVENTIONAL"}]
        end
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
      test_params = {:id => "STU100"}
      final_params = "<parameters><parameter name='ID' value='STU100'/></parameters>"
      EirbAdapter.format_search_parameters(test_params).should == final_params 
      test_params = { :blah => 123}
      final_params = "<parameters><parameter name='BLAH' value='123'/></parameters>"    
      EirbAdapter.format_search_parameters(test_params).should == final_params 
      test_params = {:foo => 3.14159265}
      final_params = "<parameters><parameter name='FOO' value='3.14159265'/></parameters>"
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
