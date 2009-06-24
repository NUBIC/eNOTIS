require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^a user "([^\"]*)" with password "([^\"]*)"$/ do |netid, password|
  @user = Factory.create(:user, {:netid => netid, :password => password})
  @user.coordinators << Factory(:coordinator)
  User.stub!(:find_by_netid).and_return(@user)
  @user.stub!(:authenticate).and_return{|p| p == password}
end

Given /^is not authorized on any studies$/ do
  @user.coordinators = []
end


When /^I log in as "([^\"]*)" with password "([^\"]*)"$/ do |netid, password|
  unless netid.blank?
    visit authentication_index_path
    fill_in "netid", :with => netid
    fill_in "password", :with => password
    click_button "login"
  end
end

