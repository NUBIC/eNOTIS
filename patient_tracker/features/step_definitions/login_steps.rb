require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^a user "([^\"]*)" with password "([^\"]*)"$/ do |netid, password|
  @user = Factory.create(:user, {:netid => netid, :password => password})
  @my_study = Factory(:study)
  Factory(:coordinator, :user => @user, :study => @my_study)
  User.stub!(:authenticate).and_return{|n,p| p == password ? @user : nil }
end

Given /^is not authorized on any studies$/ do
  @user.studies = []
end


When /^I log in as "([^\"]*)" with password "([^\"]*)"$/ do |netid, password|
  unless netid.blank?
    visit authentication_index_path
    fill_in "netid", :with => netid
    fill_in "password", :with => password
    click_button "login"
  end
end

