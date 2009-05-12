require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
  
  it "accepts a netID and validates it" do
    u = User.new
    u.stub!(:netid).and_return('net123')
    u.stub!(:password).and_return('blah')
    User.should_receive(:find_by_netid).with('net123').and_return(u)
    u.should_receive(:authenticate).with('blah').and_return(true)
    User.validate_user('net123','blah').should be_true
  end
end
