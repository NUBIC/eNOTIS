require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory(:user).should be_valid
  end
  
  it "accepts a netID and validates it" do
    u = Factory(:user, :netid => 'ord312', :password => "airport")
    User.should_receive(:find_by_netid).with('ord312').and_return(u)
    u.should_receive(:authenticated?).with('airport').and_return(true)
    User.authenticate('ord312','airport').should be_true
  end
end
