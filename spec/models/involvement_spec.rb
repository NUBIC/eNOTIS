require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Involvement do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory(:involvement).should be_valid
  end  
end
