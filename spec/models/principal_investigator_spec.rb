require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PrincipalInvestigator do
  before(:each) do
    @valid_attributes = {}
  end

  it "should create a new instance given valid attributes" do
    user = Factory(:user, :netid => "abc123")
    study = Factory(:study, :irb_number => "STU0010101")
    principal_investigator = Factory(:principal_investigator, :user => user, :study => study)
    principal_investigator.should be_valid
    study.principal_investigator.netid.should eql('abc123')
    # .map(&:netid).include?("abc123").should be_true
  end

  it "should create a new instance given valid attributes (fake study)" do
    user = Factory(:user, :netid => "abc123")
    study = Factory(:fake_study, :irb_number => "STU0010101")
    principal_investigator = Factory(:principal_investigator, :user => user, :study => study)
    principal_investigator.should be_valid
    study.principal_investigator.netid.should eql('abc123')
  end

end
