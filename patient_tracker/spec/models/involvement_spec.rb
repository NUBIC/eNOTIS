require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Involvement do
  before(:each) do
    @valid_attributes = {
      :patient_id => 1,
      :protocol_id => 1,
      :disease_site => "value for disease_site",
      :description => "value for description"
    }
  end

  it "should create a new instance given valid attributes" do
    Involvement.create!(@valid_attributes)
  end
end
