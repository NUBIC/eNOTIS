require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AuthenticationController do

  #Delete this example and add some real ones
  it "should use AuthenticationController" do
    controller.should be_an_instance_of(AuthenticationController)
  end

  it "accepts credentials and authenticates them" do
    post 'login', :id => 'abc123'
    account = mock(User)
    User.should_receive(:find_by_netid).with("abc123").and_return(account)
  end
end
