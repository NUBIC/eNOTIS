require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Race do
  before(:each) do
    @valid_attributes = {:race_type_id=>3
    }
  end

  it "should create a new instance given valid attributes" do
    Race.create!(@valid_attributes)
  end
end
