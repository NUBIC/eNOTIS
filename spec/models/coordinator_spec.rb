require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Coordinator do
  before(:each) do
    @valid_attributes = {}
  end

  it "should create a new instance given valid attributes" do
    user = Factory(:user, :netid => "abc123")
    study = Factory(:study, :irb_number => "STU0010101")
    coord = Factory(:coordinator, :user => user, :study => study)
    coord.should be_valid
    study.coordinators.map(&:netid).include?("abc123").should be_true
  end
 
  it "should create a new instance given valid attributes (fake study)" do
    user = Factory(:user, :netid => "abc123")
    study = Factory(:fake_study, :irb_number => "STU0010101")
    coord = Factory(:coordinator, :user => user, :study => study)
    coord.should be_valid
    study.coordinators.map(&:netid).include?("abc123").should be_true
  end

end
