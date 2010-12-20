require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PublicController do
  
  it "should redirect login to default path if already logged in" do
    login_as("brian")
    get :index
    response.should redirect_to(default_path)
  end
  it "should not redirect when not logged in" do
    login_as(nil)
    get :index
    response.should_not be_redirect
  end

end
