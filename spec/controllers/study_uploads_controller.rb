require 'spec_helper'

def up(name, extension = 'csv')
  File.open(File.dirname(__FILE__) + "/../uploads/#{name}.#{extension}")
end

describe InvolvementsController do
  before(:each) do
    @study = Factory(:study, :irb_number => 'STU00002629')
    StudyUpload.stub!(:create).and_return(@up = Factory(:study_upload))
    @role = Factory(:role, :study => @study, :netid => 'brian') 
    login_as("brian")
    controller.current_user.should == Bcsec.authority.find_user("brian")
  end
  
  it "should allow me to post the file to upload" do
    #post :upload, {:file => up('good')}
    #response.should redirect_to(studies_path)
    post :create, {:file => up('good'), :study_id => 'STU00002629'}
    response.should redirect_to(study_path(:id => 'STU00002629'))
  end

  it "should create a new StudyUpload with the file attached" do
    StudyUpload.should_receive(:create).and_return(Factory(:study_upload, :study => @study))
    post :create, {:file => up('good'), :study_id => 'STU00002629'}
  end

  it "should check the study upload" do
    @up.should_receive(:legit?)
    post :create, {:file => up('good'), :study_id => 'STU00002629'}
  end

  it "should should redirect with flash linking to import" do
    @up.should_receive(:legit?).and_return(false)
    post :upload, {:file => up('good'), :study_id => 'STU00002629'}
    response.should redirect_to(study_path(:id => 'STU00002629'))
    flash[:notice].should == "Oops. Your upload had some issues.<br/>Please click <a href='/studies/STU00002629/import' rel='#import'>Import</a> to see the result."
  end

  it "should deny access to an attempt to create an upload on an unauthorized study" do
    study = Factory(:study, :irb_number => 'STU00002630')
    post :create, {:file => up('good'), :study_id => study.irb_number}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

end
