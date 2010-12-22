require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdminController do
  before(:each) do
    login_as("adminnie")
  end
  it "should find the most recent uploads" do
    upin = Factory(:study_upload, :created_at => 5.days.ago)
    upout = Factory(:study_upload, :created_at => 20.days.ago)
    get :index
    assigns(:recent_uploads).include?(upin).should be_true
    assigns(:recent_uploads).include?(upout).should be_false
  end
  it "should find deadbeats" do
    duck = Activity.create(:controller => "involvements", :action => "new", :whodiddit => "joe")
    duckk = Activity.create(:controller => "involvements", :action => "create", :whodiddit => "joe")
    goose = Activity.create(:controller => "involvements", :action => "new", :whodiddit => "golden")
    get :index
    assigns(:deadbeats).should == {"golden" => [goose]}
  end
  it "should find recent entries by hand (not uploads)" do
    guns = Activity.create(:controller => "involvements", :action => "create", :whodiddit => "ban")
    germs = Activity.create(:controller => "involvements", :action => "update", :whodiddit => "ki", :created_at => 29.days.ago)
    steel = Activity.create(:controller => "involvements", :action => "new", :whodiddit => "moon")
    get :index
    assigns(:recent_handers).should == {"ban" => [guns]}
  end
end