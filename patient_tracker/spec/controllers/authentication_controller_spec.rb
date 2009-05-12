require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AuthenticationController do

  #Delete this example and add some real ones
  it "should use AuthenticationController" do
    controller.should be_an_instance_of(AuthenticationController)
  end

  it "accepts credentials and authenticates them" do
    account = User.new
    User.should_receive(:validate_user).with("abc123","blah").and_return(account)
    post 'login', :netid => 'abc123',:password => 'blah'
  end
end
