require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe EirbServices do

  before(:each) do
    # create the class to use for tesing this module
    @tester =  EirbServices::Server.new
  end
  
  it "sets the eirb connection string as a configuration option" do
    @tester.connection(:url => "http://blahblahblah.com")
    @tester.connection_url.should == "http://blahblahblah.com"
  end

  it "sets the store name for the data source" do
    @tester.connection(:storename => "eirb-test")
    @tester.storename.should == "eirb-test"
  end

  it "sets the credentials needed for eirb authentication" do
    @tester.connection(:username => "blah123", :password => "blahabc")
    @tester.username.should == "blah123"
    @tester.password.should == "blahabc"
  end

  describe "working with a valid session login" do
    before(:each) do
      @tester.connection(:url => "http://blah", :username => "foo", :password => "123")
      # Mocking out the soap services
      @driver = mock(Object)
    end
    
    it "uses the soap driver to login the user" do

    end
    
    it "creates a valid session using the connection credentials" do
      @tester.authenticate!.should be_true          
    end

    describe "with the validated user" do
      it "performs a search" do
        results = @tester.perform_search(:search => "blah")
        results.should_not be_nil 
      end
      
      it "requires at least a search parameter otherwise it throws an error" do
        lambda{@tester.perform_search}.should raise_error
      end
    end
  end

  describe "working with an invalid session login" do
    it "should return authenticated? as false" do
      @tester.authenticated?.should be_false   
    end
  end

end
