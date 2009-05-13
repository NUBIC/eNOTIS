require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AuthenticationController do

  #Delete this example and add some real ones
  it "should use AuthenticationController" do
    controller.should be_an_instance_of(AuthenticationController)
  end

  describe "the login process" do
    before(:each) do
      @account = User.new
      @account.id = 123
      @account.netid = 'abc123'
      User.stub!(:find_and_validate).and_return(@account)
    end
      
    it "accepts credentials and authenticates them" do
      controller.should_receive(:authenticate_user).with("abc123","blah").and_return(@account)
      post 'login', :netid => 'abc123',:password => 'blah'
      response.should be_redirect
    end

    it "sets the current user in the session after a successful login" do
      controller.should_receive(:authenticate_user).with("abc123",nil).and_return(@account)
      controller.should_receive(:current_user).with(@account)
      post 'login', :netid => 'abc123'
      session[:current_user].should == @account.id
      response.should be_redirect # to default page
    end

    it "sets the current user when user objet is assigned" do
      User.should_receive(:find).with(@account.id).and_return(@account)
      controller.current_user = @account
      session[:current_user].should == @account.id
    end
  end
end
