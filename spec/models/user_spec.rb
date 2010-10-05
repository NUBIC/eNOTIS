require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
  end

  #it "should create a new instance given valid attributes" do
  #  Factory(:user).should be_valid
  #end
  
#  it "accepts a netID and validates it" do
#    u = Factory(:user, :netid => 'ord312')#, :password => "airport")
#    User.should_receive(:find_by_netid).with('ord312').and_return(u)
#    Bcsec::NetidAuthenticator.should_receive(:valid_credentials?).with('ord312', 'airport').and_return(true)
#    User.authenticate('ord312','airport').should be_true
#  end
#  
#  it "should find netids that are absent from the User model" do
 #   Factory(:user, :netid => "foo")
 #   User.absent_netids(["foo"]).should == []
 #   User.absent_netids(%w(foo bar)).should == ["bar"]
 ##   User.absent_netids(%w(bar baz)).should == ["bar", "baz"]
 # end
end
