require 'spec_helper'

describe ServiceItem do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    ServiceItem.create!(@valid_attributes)
  end
end
