require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RolesController do

  before(:each) do
    login_as("brian")
    controller.current_user.should == Bcsec.authority.find_user("brian")
  end

  #Delete this example and add some real ones
  it "should use RolesController" do
    controller.should be_an_instance_of(RolesController)
  end

  # Registar and clearcats need this to exist 
  it "should respond with role data for GET requests including netids" do
    role = Factory(:role, :netid => "baa321", :study => Factory(:study, :approved_date => 1.year.ago))
    get :show, {:id => "baa321"}
    response.should be_success
  end

  it "should not fail if the approved_date is nil" do
    role = Factory(:role, :netid => "abc123", :study => Factory(:study, :approved_date => nil))
    get :show, {:id => "abc123"}
    response.should be_success
  end

  it "should not fail the the user does not exist" do
    get :show, {:id => "bob123"}
    response.should_not be_success 
  end


end
