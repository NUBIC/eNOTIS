require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^a user "([^\"]*)" with password "([^\"]*)"$/ do |netid, password|
  user = Factory.create(:user, {:netid => netid})#, :password => password})
  User.stub!(:authenticate).and_return{|n,p| p == password ? user : nil }
end

Given /^"([^\"]*)" has access to study id "([^\"]*)"$/ do |netid, id|
  study =  Study.find_by_irb_number(id)
  user =  User.find_by_netid(netid)
  Given "a study with id \"#{id}\"" unless study
  study = Study.find_by_irb_number(id)
  c = Factory(:coordinator, :user => user, :study => study)
  study = Study.find_by_irb_number(id)
  study.has_coordinator?(user).should be_true
end

Given /^a study with id "([^\"]*)"$/ do |id|
  Factory.create(:fake_study, :irb_number => id, :irb_status => "Not Under IRB Purview")
end

Given /^"([^\"]*)" is not authorized on any studies$/ do |netid|
  User.find_by_netid(netid).studies = []
end

When /^I log in as "([^\"]*)" with password "([^\"]*)"$/ do |netid, password|
  unless netid.blank?
    visit authentication_index_path
    fill_in "netid", :with => netid
    fill_in "password", :with => password
    click_button "login"
  end
end

Given /^I log in as "([^\"]*)"$/ do |name|
  Given "a user \"#{name}\" with password \"314159\""
  if User.find_by_netid(name).studies.blank?
    Given "\"#{name}\" has access to study id \"STU000314\""
  end
  Given "I log in as \"#{name}\" with password \"314159\""
end
