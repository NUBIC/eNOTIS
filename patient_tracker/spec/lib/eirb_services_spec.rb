require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe EirbServices do

  before(:each) do
    # create the class to use for tesing this module
    @tester =  EirbServices::Server.new
  end
  
  it "sets the eirb connection string as a configuration option" do
    @tester.configure(:url => "http://blahblahblah.com")
    @tester.connection_url.should == "http://blahblahblah.com"
  end

  it "sets the store name for the data source" do
    @tester.configure(:storename => "eirb-test")
    @tester.storename.should == "eirb-test"
  end

  it "sets the credentials needed for eirb authentication" do
    @tester.configure(:username => "blah123", :password => "blahabc")
    @tester.username.should == "blah123"
    @tester.password.should == "blahabc"
  end

  describe "using full configuration parameters" do
    before(:each) do
      @test_params = {:storename => "eirbtest", :url => "http://blah.com", :username => "foo", :password => "123"}

      # mock soap objects
      @factory = mock(SOAP::WSDLDriverFactory)
      SOAP::WSDLDriverFactory.stub!(:new).with(@test_params[:url]).and_return(@factory)
      @driver = mock(SOAP::RPC::Driver)
      @factory.stub!(:create_rpc_driver).and_return(@driver)
      @result = mock(SOAP::Mapping::Object)
      @tester.configure(@test_params)
    end
   
    it "makes a connection driver using the config url" do
      @tester.driver.should be_nil
      @tester.create_driver
      @tester.driver.should_not be_nil
    end

    it "will throw a DataServiceError if login attempted before driver is created" do
      lambda {@tester.login}.should raise_error(EirbServices::DataServiceError)
    end

    describe "with valid login credentials" do
      before(:each) do
        @tester.create_driver
        @driver.should_receive(:login).with({
        :storeName => @test_params[:storename],
        :userName => @test_params[:username],
        :password => @test_params[:password]}).and_return(@result)
      end  
      
      it "calls the soap driver with login credentials" do
        @tester.login.should be_true  
      end

      it "sets the session if the login was sucessfull" do
        @tester.session.should be_nil
        @tester.login.should be_true
        @tester.session.should_not be_nil
      end

      it "knows if it is authenticated if their is a session" do
        @tester.authenticated?.should be_false
        @tester.login
        @tester.authenticated?.should be_true
      end

      describe "performing a search with the active session" do
        before(:each) do
          @tester.login
        end

        it "can perform a search" do
          @driver.should_receive(:performSearch).and_return([])
          @tester.perform_search({:blah => "foo"}).should_not be_nil 
        end

        it "calls the driver to perform a search" do
          search_params = {:svcSessionToken => @result, :savedSearchName => "idStatus",
            :startRow => 1, :numRows => -1, :expandMultiValueCells => false,
            :parameters => "<parameters><parameter name='ID' value='STU00000706'/></parameters>"}
          @driver.should_receive(:performSearch).with(search_params).and_return([])
          @tester.perform_search({:savedSearchName => "idStatus", :startRow =>1, :numRows =>-1,
                                 :expandMultiValueCells => false,
                                 :parameters => "<parameters><parameter name='ID' value='STU00000706'/></parameters>"})
        end

        it "has wrapper search for idStatus" do
          id_search_params = {:svcSessionToken => @result, :savedSearchName => "idStatus",
            :startRow => 1, :numRows => -1, :expandMultiValueCells => false,
            :parameters => "<parameters><parameter name='ID' value='STU00000706'/></parameters>"}
         
          @driver.should_receive(:performSearch).with(id_search_params).and_return(mock(SOAP::Mapping::Object))          
          @tester.find_status_by_id("STU00000706")
        end
      end

    end 

   end

  describe "working with an invalid session login" do
    it "should return authenticated? as false" do
      @tester.authenticated?.should be_false   
    end
  end

  it "can convert a hash to search parameter format of the eirb service" do
    test_params = {:id => "STU100"}
    final_params = "<parameters><parameter name='ID' value='STU100'/></parameters>"
    EirbServices::Server.format_search_parameters(test_params).should == final_params 
    test_params = { :blah => 123}
    final_params = "<parameters><parameter name='BLAH' value='123'/></parameters>"    
    EirbServices::Server.format_search_parameters(test_params).should == final_params 
    test_params = {:foo => 3.14159265}
    final_params = "<parameters><parameter name='FOO' value='3.14159265'/></parameters>"
    EirbServices::Server.format_search_parameters(test_params).should == final_params 
  end

end
