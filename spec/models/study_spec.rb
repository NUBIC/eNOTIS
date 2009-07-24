require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Study do
  before(:each) do
  end
  
  it "should create a new instance given valid attributes" do
    Factory(:study).should be_valid
  end
  
  it "should tell us when the study is stale" do
    @study = Factory(:study, :synced_at => 3.days.ago)
    @study.should be_stale
    @study.synced_at = 3.minutes.ago
    @study.should_not be_stale
  end
  it "should allow us to sync with different data" do
    @study = Factory(:study, :synced_at => 3.days.ago, :description => "Randomized Evaluation of Sinusitis With Vitamin A")
    @study.sync!({:description => "Randomized Evaluation of Sinusitis With Vitamin A440"})
    @study.description.should == "Randomized Evaluation of Sinusitis With Vitamin A440"
    @study.synced_at.should >= 1.minute.ago
  end
  it "should tell us when we can accrue subjects" do
    ["Approved", "Conditional Approval", "Exempt Approved", "Not Under IRB Purview", "Revision Open"].each do |status|
      Factory(:study, :status => status).may_accrue?.should be_true
    end
    ["Rejected", "Revision Closed", "Suspended", "Withdrawn", "foo", nil].each do |status|
      Factory(:study, :status => status).may_accrue?.should be_false
    end
  end
  
  describe "with subjects" do
    it "should add a new subject, regardless of status(open) or subject syncing" do
      params = {:ethnicity=>32,:gender=>30}
      study = Factory.create(:study, :status => "open")
      study.add_subject(Factory(:subject, :synced_at => nil),params)
      study.add_subject(Factory(:subject, :synced_at => 2.minutes.ago),params)
      study.should have(2).involvements
    end
    it "should add a new subject, regardless of status(closed) or subject syncing" do
      params = {:ethnicity=>32,:gender=>30}
      study = Factory.create(:study, :status => "closed")
      study.add_subject(Factory(:subject, :synced_at => nil),params)
      study.add_subject(Factory(:subject, :synced_at => 2.minutes.ago),params)
      study.should have(2).involvements
    end
    it "should add a new subject once and only once" do
      params = {:ethnicity=>32,:gender=>30}
      study = Factory.create(:study, :status => "closed")
      subject = Factory(:subject, :synced_at => nil)
      5.times { study.add_subject(subject,params) }
      study.should have(1).involvements
    end
  end
  
  describe "with users" do
    it "should authorize users added to study.users" do
      pending
      study = Factory.create(:study)
      user = Factory(:user)
      study.users << u
      study.authorized_user?(u).should == true
    end
    it "should not authorize other users" do
      pending
      study = Factory.create(:study)
      user = Factory(:user)
      study.authorized_user?(u).should == false
    end
  end
end
