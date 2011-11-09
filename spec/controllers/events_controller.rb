require 'spec_helper'

describe EventsController do
  before(:each) do
    @study = Factory(:study, :irb_number => 'STU00002629')
    @involvement = Factory(:involvement,:study=>@study)
    @event = Factory(:involvement_event,:involvement=>@involvement)
    #@role = Factory(:role, :study => @study, :netid => 'brian') 
    login_as("brian")
    controller.current_user.should == Bcsec.authority.find_user("brian")
  end
  
  it "should deny access to an attempt to create an involvement event on an unauthorized study" do
    post :create, {:involvement_id=>@involvement.id,:involvement=>{}}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to edit an involvement event on an unauthorized study" do
    post :edit, {:involvement_id=>@involvement.id,:id=>@event.id}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to update an involvement event on an unauthorized study" do
    post :update, {:involvement_id=>@involvement.id,:id=>@event.id}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to delete an involvement event on an unauthorized study" do
    post :destroy, {:involvement_id=>@involvement.id,:id=>@event.id}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to create an involvement event on a managed study" do
    @study.update_attributes(:managing_system=>"NOTIS")
    @role = Factory(:role, :study => @study, :netid => 'brian') 
    post :create, {:involvement_id=>@involvement.id,:involvement=>{}}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to edit an involvement event on a managed study" do
    @study.update_attributes(:managing_system=>"NOTIS")
    @role = Factory(:role, :study => @study, :netid => 'brian') 
    post :edit, {:involvement_id=>@involvement.id,:id=>@event.id}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end


  it "should deny access to an attempt to update an involvement event on a managed study" do
    @study.update_attributes(:managing_system=>"NOTIS")
    @role = Factory(:role, :study => @study, :netid => 'brian') 
    post :update, {:involvement_id=>@involvement.id,:id=>@event.id}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end

  it "should deny access to an attempt to delete an involvement event on a managed study" do
    @study.update_attributes(:managing_system=>"NOTIS")
    @role = Factory(:role, :study => @study, :netid => 'brian') 
    post :destroy, {:involvement_id=>@involvement.id,:id=>@event.id}
    response.should redirect_to(studies_path)
    flash[:notice].should == "Access Denied"
  end
end
