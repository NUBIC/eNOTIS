require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AuthenticationController do

  describe "the login process" do
    before(:each) do
      @account = Factory(:user)
      User.stub!(:authenticate).and_return(@account)
    end
      
    it "accepts credentials and authenticates them" do
      controller.should_receive(:logout_keeping_session!)
      User.should_receive(:authenticate).with("abc123","blah").and_return(@account)
      post 'login', :netid => 'abc123', :password => 'blah'
      response.should be_redirect
    end

    it "sets the current user in the session after a successful login" do
      post 'login', :netid => 'abc123', :password => 'blah'
      controller.session[:user_id].should == @account.id
      response.should redirect_to(default_path)
    end
  end
end
