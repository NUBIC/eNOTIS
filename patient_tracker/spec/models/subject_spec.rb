require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Subject do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory(:subject).should be_valid
  end
  
  describe "syncing Subject with EDW" do
    # possible scenarios
    #   1. EDW down
    #   2. record not inserted in EDW yet (nightly work)
    #   3. local user only - pt will never be in EDW (no medical record) 

    it "should tell us when the subject is not synced" do
      @subject = Factory(:subject, :synced_at => nil)
      @subject.should_not be_synced
    end
    
    it "should tell us when the subject is stale" do
      @subject = Factory(:subject, :synced_at => nil)
      @subject.should be_stale
      @subject.synced_at = 3.minutes.ago
      @subject.should_not be_stale
      @subject.synced_at = 2.days.ago
      @subject.should be_stale
    end
    
    it "should allow us to sync with different data" do
      @subject = Factory(:subject, :synced_at => nil, :address_line1 => "31 Circle Drive")
      @subject.sync!({:address_line1 => "314 Circle Dr."})
      @subject.address_line1.should == "314 Circle Dr."
    end
    
    it "should save the old data" do
      @subject = Factory(:subject, :synced_at => nil, :address_line1 => "31 Circle Drive", :pre_sync_data => nil)
      @subject.sync!({:address_line1 => "314 Circle Dr."})
      @subject.address_line1.should == "314 Circle Dr."
      @subject.pre_sync_data.should_not be_nil
      @subject.pre_sync_data.should include("31 Circle Drive")
    end

    it "should not save the old data if we're already synced" do
      @subject = Factory(:subject, :synced_at => 2.days.ago, :address_line1 => "31 Circle Drive", :pre_sync_data => nil)
      @subject.sync!({:address_line1 => "314 Circle Dr."})
      @subject.address_line1.should == "314 Circle Dr."
      @subject.pre_sync_data.should be_nil
    end

    
  end
  
  
  
end
