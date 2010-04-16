require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

def up(name)
  File.open(File.dirname(__FILE__) + "/../uploads/#{name}.csv")
end

describe StudyUpload do
  before(:each) do
  end
  
  it "should create a new instance given valid attributes" do
    Factory(:study_upload).should be_valid
  end
  
  it "should fail if upload is blank" do
    @up = StudyUpload.new(:user_id => 2, :study_id => 2, :upload => nil)
    @up.legit?.should be_false
    @up.summary.should =~ /Please upload a file/
  end
  
  it "should fail if upload doesn't have valid columns" do
    @up = Factory(:study_upload, :upload => up('missing_columns'))
    @up.legit?.should be_false
    @up.summary.should =~ /missing required columns/
  end
  
  it "should have errors if upload has blank or invalid race, ethnicity, or gender values" do
    @up = Factory(:study_upload, :upload => up('blank_terms'))
    @up.legit?.should be_false
    @up.summary.should =~ /and fix/
    @up = Factory(:study_upload, :upload => up('bad_terms'))
    @up.legit?.should be_false
    @up.summary.should =~ /and fix/
  end
  
  it "should have errors if mrn, fn/ln/dob, case number are missing" do
    @up = Factory(:study_upload, :upload => up('missing_identifiers'))
    @up.legit?.should be_false
    @up.summary.should =~ /and fix/
  end
  
  it "should have errors if there are no event dates" do
    @up = Factory(:study_upload, :upload => up('blank_event_dates'))
    @up.legit?.should be_false
    @up.summary.should =~ /and fix/
  end
  
  it "should be successful otherwise" do
    @up = Factory(:study_upload, :upload => up('good'))
    @up.legit?.should be_true
    @up.summary.should =~ /7 subjects/
    Subject.all.map(&:birth_date).compact.size.should == 5
    InvolvementEvent.count.should == 7
  end
end
