require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^a user "([^\"]*)" with password "([^\"]*)"$/ do |netid, password|
  @user = Factory(:user, {:netid => netid})
  @user.stub!(:authenticate).and_return(true) #{|p| p == password }
  @user.coordinators << Factory(:coordinator)  
end

When /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |netid, password|
  unless netid.blank?
    visit authentication_index_path
    fill_in "netid", :with => netid
    fill_in "password", :with => password
    click_button "login"
  end
end
