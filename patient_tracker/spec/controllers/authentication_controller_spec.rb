require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AuthenticationController do

  #Delete this example and add some real ones
  it "should use AuthenticationController" do
    controller.should be_an_instance_of(AuthenticationController)
  end

  describe "the login process" do
    before(:each) do
      @account = User.new
      @account.netid = 'abc123'
      User.stub!(:validate_user).and_return(@account)
    end
      
    it "accepts credentials and authenticates them" do
      User.should_receive(:validate_user).with("abc123","blah").and_return(@account)
      post 'login', :netid => 'abc123',:password => 'blah'
    end

    it "sets the current user in the session after a successful login" do
      post 'login', :netid => 'abc123'
      response.should be_redirect # to default page
      session[:current_user].should == @account.id
    end
  end
end
