require 'spec_helper'

def up(name, extension = 'csv')
  File.open(File.dirname(__FILE__) + "/../uploads/#{name}.#{extension}")
end

describe InvolvementsController do
  before(:each) do
    @study = Factory(:study, :irb_number => 'STU00002629')
    @subject = Factory(:fake_subject)
    @involvement = Factory(:involvement,:study=>@study,:subject=>@subject)
    StudyUpload.stub!(:create).and_return(@up = Factory(:study_upload))
    @role = Factory(:role, :study => @study, :netid => 'brian') 
    login_as("brian")
    controller.current_user.should == Bcsec.authority.find_user("brian")
  end
  
  it "should deny access to an attempt to create an involvement on an unauthorized study" do
    study = Factory(:study, :irb_number => 'STU00002630')
    post :create, {:study => {:irb_number=>'STU00002630'},:involvement=>{}}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to edit an involvement on an unauthorized study" do
    study = Factory(:study, :irb_number => 'STU00002630')
    subject = Factory(:fake_subject)
    involvement = Factory(:involvement)
    post :edit, {:id=>involvement.id}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to view an involvement on an unauthorized study" do
    study = Factory(:study, :irb_number => 'STU00002630')
    subject = Factory(:fake_subject)
    involvement = Factory(:involvement)
    get :show, {:id=>involvement.id}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to update an involvement on an unauthorized study" do
    study = Factory(:study, :irb_number => 'STU00002630')
    subject = Factory(:fake_subject)
    involvement = Factory(:involvement)
    post :update, {:id=>involvement.id}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to delete an involvement on an unauthorized study" do
    study = Factory(:study, :irb_number => 'STU00002630')
    subject = Factory(:fake_subject)
    involvement = Factory(:involvement)
    post :destroy, {:id=>involvement.id}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  
  it "should deny access to an attempt to create an involvement on a managed study" do
    @study.update_attributes(:managing_system=>"NOTIS")
    post :create, {:study => {:irb_number=>@study.irb_number},:involvement=>{}}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to edit an involvement on a managed study" do
    @study.update_attributes(:managing_system=>"NOTIS")
    post :edit, {:id=>@involvement.id}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to update an involvement on a managed study" do
    @study.update_attributes(:managing_system=>"NOTIS")
    post :update, {:id=>@involvement.id}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to delete an involvement on a managed study" do
    @study.update_attributes(:managing_system=>"NOTIS")
    post :destroy, {:id=>@involvement.id}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end
end
