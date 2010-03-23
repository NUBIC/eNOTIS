require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^a user "([^\"]*)" with password "([^\"]*)"$/ do |netid, password|
  user = Factory.create(:user, {:netid => netid})
  user.should be_valid
  User.stub!(:authenticate).and_return{|n,p| p == password ? user : nil }
end

Given /^a user "([^\"]*)" with password "([^\"]*)"(?: on study "([^\"]*))?"$/ do |netid, password, irb_number|
  # user
  Given %(a user "#{netid}" with password "#{password}")
  # study and coordinator
  Given %("#{netid}" is on study "#{irb_number}") unless irb_number.blank?
end

Given /^a nonuser "([^\"]*)" with password "([^\"]*)"$/ do |netid, password|
  User.stub!(:authenticate).and_return{|n,p| p == password ? false : nil }
end

Given /^"([^\"]*)" is on study "([^\"]*)"$/ do |netid, irb_number|
  #user
  user = User.find_by_netid(netid)
  user.should be_valid
  # study
  study = Study.find_by_irb_number(irb_number) || Factory.create(:fake_study, :irb_number => irb_number, :irb_status => "Not Under IRB Purview")
  study.should be_valid
  # coordinator
  coordinator = Factory(:coordinator, :user => user, :study => study)
  coordinator.should be_valid
  study.has_coordinator?(user).should be_true
end

Given /^a study with id "([^\"]*)"$/ do |irb_number|
  study = Study.find_by_irb_number(irb_number) || Factory.create(:fake_study, :irb_number => irb_number, :irb_status => "Not Under IRB Purview")
  study.should be_valid
end

Given /^a study "([^\"]*)" with id "([^\"]*)" and irb_status "([^\"]*)"$/ do |title, irb_number, irb_status|
  Factory.create(:fake_study, :title => title, :name => title, :irb_number => irb_number, :irb_status => irb_status)
end

Given /^I log in as "([^\"]*)" with password "([^\"]*)" on study "([^\"]*)"$/ do |netid, password, irb_number|
  Given %(a user "#{netid}" with password "#{password}" on study "#{irb_number}")
  Given %(I log in as "#{name}" with password "#{password}")
end

Given /^I log in as admin "([^\"]*)" with password "([^\"]*)"$/ do |netid, password|
  user = Factory.create(:user, {:netid => netid})
  user.should be_valid
  User.stub!(:find_by_id).and_return(user)
  User.stub!(:authenticate).and_return{|n,p| p == password ? user : nil }
  user.stub!(:admin?).and_return(true)
  Given %(I log in as "#{name}" with password "#{password}")
  Then "I should see \"(#{netid})\""
end

Given /^"([^\"]*)" is not authorized on any studies$/ do |netid|
  user = User.find_by_netid(netid)
  user.should_not be_nil
  user.studies.should == []
end

When /^I log in as "([^\"]*)" with password "([^\"]*)"$/ do |netid, password|
  unless netid.blank?
    visit default_path
    fill_in "netid", :with => netid
    fill_in "password", :with => password
    click_button "login"
  end
end

Given /^the following users$/ do |table|
  table.hashes.each{|hash| Factory.create(:user, hash) }
end

Given /^a user "([^\"]*)" named "([^\"]*)" "([^\"]*)"$/ do |netid, fn, ln|
  Factory.create(:user, {:netid => netid, :first_name => fn, :last_name => ln})
end