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

  it "should be invalid without user or study" do
    Coordinator.new(:user_id => 3).should have(1).error_on(:study_id)
    Coordinator.new(:study_id => 1).should have(1).error_on(:user_id)
  end
end
