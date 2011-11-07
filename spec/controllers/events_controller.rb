require 'spec_helper'

def up(name, extension = 'csv')
  File.open(File.dirname(__FILE__) + "/../uploads/#{name}.#{extension}")
end

describe EventsController do
  before(:each) do
    @study = Factory(:study, :irb_number => 'STU00002629')
    @involvement = Factory(:involvement,:study=>@study)
    #@role = Factory(:role, :study => @study, :netid => 'brian') 
    login_as("brian")
    controller.current_user.should == Bcsec.authority.find_user("brian")
  end
  
  it "should deny access to an attempt to create an involvement event on an unauthorized study" do
    study = Factory(:study, :irb_number => 'STU00002630')
    post :create, {:involvement_id=>@involvement.id,:involvement=>{}}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to edit an involvement event on an unauthorized study" do
    study = Factory(:study, :irb_number => 'STU00002630')
    subject = Factory(:fake_subject)
    involvement = Factory(:involvement)
    post :edit, {:involvement_id=>@involvement.id}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to view an involvement event on an unauthorized study" do
    study = Factory(:study, :irb_number => 'STU00002630')
    subject = Factory(:fake_subject)
    involvement = Factory(:involvement)
    get :show, {:id=>involvement.id}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to update an involvement event on an unauthorized study" do
    study = Factory(:study, :irb_number => 'STU00002630')
    subject = Factory(:fake_subject)
    involvement = Factory(:involvement)
    post :update, {:id=>involvement.id}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to delete an involvement event on an unauthorized study" do
    study = Factory(:study, :irb_number => 'STU00002630')
    subject = Factory(:fake_subject)
    involvement = Factory(:involvement)
    post :destroy, {:id=>involvement.id}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

end
