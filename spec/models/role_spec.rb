require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Role do
  before(:each) do
    @valid_attributes = {}
  end

  describe "Basic Role behavior" do
    before(:each) do 
      @user = Factory(:user, :netid => "abc123")
      @study = Factory(:study, :irb_number => "STU0010101")
      @role = Factory(:role, :user => @user, :study => @study)
    end

    it "should create a new instance given valid attributes" do
      @role.should be_valid
      @study.roles.map(&:netid).include?("abc123").should be_true
    end
   
    it "should create a new instance given valid attributes (fake study)" do
      @role.should be_valid
      @study.roles.map(&:netid).include?("abc123").should be_true
    end

    it "can or cannot accrue patients" do
      can_role = Factory(:role, :user => @user,
                         :study => @study, 
                         :consent_role => "Obtaining")
      cannot_role = Factory(:role, :user => @user,
                         :study => @study, 
                         :consent_role => "None")
      can_role.can_accrue?.should be_true
      cannot_role.can_accrue?.should be_false
    end
  end

  it "should be invalid without user or study" do
    Role.new(:user_id => 3).should have(1).error_on(:study_id)
    Role.new(:study_id => 1).should have(1).error_on(:user_id)
  end
end
