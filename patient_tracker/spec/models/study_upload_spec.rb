require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudyUpload do
  before(:each) do
    @valid_attributes = {
      :study_id => 1,
      :user_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    StudyUpload.create!(@valid_attributes)
  end
end
