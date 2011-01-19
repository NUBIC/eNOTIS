require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Role do
  before(:each) do 
    #@user = Factory(:user, :netid => "abc123")
    @netid='abc123'
    @study = Factory(:study, :irb_number => "STU0010101")
    @role = Factory(:role, :netid => @netid, :study => @study)
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
    can_role = Factory(:role, :netid => @netid,
                       :study => @study, 
                       :consent_role => "Obtaining")
    cannot_role = Factory(:role, :netid => @netid,
                       :study => @study, 
                       :consent_role => "None")
    can_role.can_accrue?.should be_true
    cannot_role.can_accrue?.should be_false
  end
  
  it "should return roles in alpha older by project role" do
    @study = Factory(:study, :irb_number => "STU0010102")
    @r1 = Factory(:role, :netid => "111yyy", :study => @study, :project_role => "PI")
    @r2 = Factory(:role, :netid => "222zzz", :study => @study, :project_role => "Coordinator")
    @study.roles.should == [@r2, @r1]
  end
  
  it "should be invalid without netid or study" do
    Role.new(:netid => 'test').should have(1).error_on(:study_id)
    Role.new(:study_id => 1).should have(1).error_on(:netid)
  end
  
  it "should print last name" do
    Pers::Person.stub!(:find_by_username).and_return(mock(Pers::Person, :last_name => "Smith"))
    Factory(:role, :netid => "smithy").last_name.should == "Smith"
  end
  it "should print last name, first middle" do
    Pers::Person.stub!(:find_by_username).and_return(mock(Pers::Person, :last_name => "Smith", :first_name => "John", :middle_name => "Q"))
    Factory(:role, :netid => "smithy").last_first_middle.should == "Smith, John Q"
  end
end
