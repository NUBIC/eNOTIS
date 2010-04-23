require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CoInvestigator do
  before(:each) do
    @valid_attributes = {}
  end

  it "should create a new instance given valid attributes" do
    user = Factory(:user, :netid => "abc123")
    study = Factory(:study, :irb_number => "STU0010101")
    co_investigator = Factory(:co_investigator, :user => user, :study => study)
    co_investigator.should be_valid
    study.co_investigators.map(&:netid).include?("abc123").should be_true
  end

  it "should create a new instance given valid attributes (fake study)" do
    user = Factory(:user, :netid => "abc123")
    study = Factory(:fake_study, :irb_number => "STU0010101")
    co_investigator = Factory(:co_investigator, :user => user, :study => study)
    co_investigator.should be_valid
    study.co_investigators.map(&:netid).include?("abc123").should be_true
  end

end
