require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Coordinator do
  before(:each) do
    @valid_attributes = {}
  end

  it "should create a new instance given valid attributes" do
    Factory(:coordinator).should be_valid
  end
  
end
