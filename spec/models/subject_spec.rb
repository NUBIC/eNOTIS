require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Subject do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory(:subject).should be_valid
  end
  
  it "should handle two digit years in dates" do
    Subject.new("birth_date"=>"12/18/34").birth_date.should == Date.parse("1934-12-18")
    Subject.new("birth_date"=>"12/18/07").birth_date.should == Date.parse("2007-12-18")
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

    it "should move all involvements when synced" do
      @subject = Factory(:subject)
      @subject2 = Factory(:subject,:synced_at=>nil)
      2.times{Factory(:involvement,:subject => @subject2)}
      @subject2.should have(2).involvement
      @subject.merge!(@subject2)
      @subject.should have(2).involvements
    end
  end
  
  describe "finding and creating" do
    before(:each) do
      @found_subject = Factory(:subject)
      @created_subject = Factory(:subject)
      @params = {:subject => {}}
    end
    it "should find a subject, by params" do
      Subject.should_receive(:find).and_return(@found_subject)
      @params[:subject] = {:mrn => "90210", :first_name => "Pikop N", :last_name => "Dropov", :birth_date => "1934-02-12"}
      Subject.find_or_create(@params).should == @found_subject    
    end
    it "should create a subject if it isn't found" do
      Subject.should_receive(:find).and_return(nil)
      Subject.should_receive(:create).and_return(@created_subject)
      @params[:subject] = {:first_name => "Pikop N", :last_name => "Dropov", :birth_date => "1934-02-12"}
      Subject.find_or_create(@params).should == @created_subject
    end
    it "should return nil if not found or created" do
      Subject.should_receive(:find).and_return(nil)
      Subject.should_receive(:create).and_return(nil)
      @params[:subject] = {:mrn => "90210", :first_name => "Pikop N", :last_name => "Dropov", :birth_date => "1934-02-12"}
      Subject.find_or_create(@params).should == nil
    end
  end
  
end
