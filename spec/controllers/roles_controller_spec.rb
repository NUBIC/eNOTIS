require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RolesController do

  #Delete this example and add some real ones
  it "should use RolesController" do
    controller.should be_an_instance_of(RolesController)
  end

  # Registar and clearcats need this to exist 
  it "should respond with role data for GET requests including netids" do
    user = Factory(:user, :netid => 'baa321')
    role = Factory(:role, :user => user, :study => Factory(:study, :approved_date => 1.year.ago))
    User.should_receive(:find_by_netid).and_return(user)
    get :show, {:id => "baa321"}
    response.should be_success
  end

  it "should not fail if the approved_date is nil" do
    user = Factory(:user, :netid => 'abc123')
    role = Factory(:role, :user => user, :study => Factory(:study, :approved_date => nil))
    User.should_receive(:find_by_netid).and_return(user)
    get :show, {:id => "abc123"}
    response.should be_success
  end
end
