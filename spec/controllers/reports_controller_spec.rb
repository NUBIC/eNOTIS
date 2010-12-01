require 'spec_helper'


describe ReportsController do
  before(:each) do
    @study = Factory(:study, :irb_number => 'STU00002629')
    @unauthorized_study = Factory(:study, :irb_number => 'STU00002630')
    controller.stub!(:user_must_be_logged_in)
    @user = Factory(:user)
    @role = Factory(:role,:study=>@study,:user=>@user) 
    controller.stub!(:current_user).and_return(@user)
  end
  
  it "should deny access to an attempt to view index report page for unauthorized study" do
    get :index, {:study=>'STU00002630'}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to view nih report for unauthorized user" do
    subject = Factory(:fake_subject)
    involvement = Factory(:involvement)
    get :nih, {:study=>'STU00002630'}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end
  it "should deny access to an attempt to view new report for unauthorized user" do
    involvement = Factory(:involvement)
    get :new, {:study=>'STU00002630'}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to create report for unauthorized user" do
    subject = Factory(:fake_subject)
    involvement = Factory(:involvement)
    post :create,{:study=>'STU00002630'}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

end
