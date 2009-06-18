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
      @subject = Factory(:subject, :last_synced => nil)
      @subject.synced?.should be_false
    end
    
    
    
  end
  
  
  
end
