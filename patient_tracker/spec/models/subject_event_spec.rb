require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubjectEvent do
  before(:each) do
    @valid_attributes = {
      :protocol_id => 1,
      :status => "value for status",
      :status_date => Date.today,
      :subject_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    SubjectEvent.create!(@valid_attributes)
  end
end
