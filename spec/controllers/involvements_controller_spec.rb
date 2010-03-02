require 'spec_helper'

def up(name)
  File.open(File.dirname(__FILE__) + "/../uploads/#{name}.csv")
end

describe InvolvementsController do
  before(:each) do
    @study = Factory(:study, :irb_number => 'STU00002629')
    StudyUpload.stub!(:create).and_return(@up = Factory(:study_upload))
    controller.stub!(:user_must_be_logged_in)
    controller.stub!(:current_user).and_return(@user = User.create)
  end
  
  it "should allow me to post the file to upload" do
    post :upload, {:file => up('good')}
    response.should redirect_to(studies_path)
    post :upload, {:file => up('good'), :study_id => 'STU00002629'}
    response.should redirect_to(study_path(:id => 'STU00002629'))
  end

  it "should create a new StudyUpload with the file attached" do
    StudyUpload.should_receive(:create).and_return(Factory(:study_upload))
    post :upload, {:file => @file, :study_id => 'STU00002629'}
  end
  it "should check the study upload" do
    @up.should_receive(:legit?)
    post :upload, {:file => @file, :study_id => 'STU00002629'}
  end
  it "should should redirect with flash based on the check" do
    @up.should_receive(:legit?).and_return(false)
    @up.should_receive(:summary).and_return("boo")
    post :upload, {:file => @file, :study_id => 'STU00002629'}
    response.should redirect_to(study_path(:id => 'STU00002629'))
    flash[:error].should == "boo"
    
    @up.should_receive(:legit?).and_return(true)
    @up.should_receive(:summary).and_return("whee")
    post :upload, {:file => @file, :study_id => 'STU00002629'}
    response.should redirect_to(study_path(:id => 'STU00002629'))
    flash[:notice].should == "whee"
  end
end
