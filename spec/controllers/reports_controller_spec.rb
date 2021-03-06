require 'spec_helper'


describe ReportsController do
  before(:each) do
    @study = Factory(:study, :irb_number => 'STU00002629')
    @unauthorized_study = Factory(:study, :irb_number => 'STU00002630')
    @role = Factory(:role, :study => @study, :netid => 'brian') 
    login_as("brian")
    controller.current_user.should == Bcsec.authority.find_user("brian")
  end
  
  it "should deny access to an attempt to view index report page for unauthorized study" do
    get :index, {:study=>'STU00002630'}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to view nih report for unauthorized user" do
    subject = Factory(:fake_subject)
    involvement = Factory(:involvement)
    get :nih,  {:study=>'STU00002630'}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end
  it "should deny access to an attempt to view new report for unauthorized user" do
    involvement = Factory(:involvement)
    get :new,  {:study=>'STU00002630'}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to create report for unauthorized user" do
    subject = Factory(:fake_subject)
    involvement = Factory(:involvement)
    post :create,{:study=>{:irb_number=>'STU00002630'}}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

end
