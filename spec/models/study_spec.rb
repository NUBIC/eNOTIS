require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Study do

  before(:each) do
    @study = Factory(:study)
    @study.irb_number = "STU0001031"
  end
  it "should scope by user" do
    @notmystudy = Factory(:study)
    Factory(:role, :netid => "usergey", :study => @study)
    Factory(:role, :netid => "adminnie", :study => @notmystudy)
    Study.with_user("usergey").should == [@study]
  end
  it "should not be valid with out an irb_number" do
    @study.irb_number = nil
    @study.valid?.should be_false
    @study.irb_number = "STU0001031"
    @study.valid?.should be_true
  end

  it "should tell us when we can accrue subjects" do
    ["Approved", "Exempt Approved", "Not Under IRB Purview", "Revision Closed", "Revision Open"].each do |status|
      Factory(:study, :irb_status => status).can_accrue?.should be_true
    end
    ["Rejected", "Suspended", "Withdrawn", "foo", nil].each do |status|
      Factory(:study, :irb_status => status).can_accrue?.should be_false
    end
  end

  it "should override the default to_param method" do
    @study.to_param.should == @study.irb_number
  end

  describe "Changes to the edit status of a study" do

    it "can be set to a read only" do
      @study.read_only!
      @study.read_only.should be_true
    end

    it "can have a read only message for the user" do
      @study.read_only!("This study is managed in NOTIS")
      @study.read_only_msg.should == "This study is managed in NOTIS"
    end

    it "can clear the read only status" do
      @study.editable!
      @study.read_only.should be_false
      @study.read_only_msg.should be_nil
    end
  end
end
