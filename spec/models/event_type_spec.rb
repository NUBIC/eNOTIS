require 'spec_helper'

describe EventType do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    EventType.create!(@valid_attributes)
  end
end
