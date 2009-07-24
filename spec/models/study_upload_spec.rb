require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudyUpload do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory(:study_upload).should be_valid
  end
end
