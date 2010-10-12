require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^"([^\"]*)" is on study "([^\"]*)"$/ do |netid, irb_number|
  study = Study.find_by_irb_number(irb_number) || Factory.create(:fake_study, :irb_number => irb_number, :irb_status => "Not Under IRB Purview")
  study.should be_valid
  # coordinator
  coordinator = Factory(:role_accrues, :netid => netid, :study => study)
  coordinator.should be_valid
  Study.with_user(netid).include?(study).should be_true
end

Given /^a study with id "([^\"]*)"$/ do |irb_number|
  study = Study.find_by_irb_number(irb_number) || Factory.create(:fake_study, :irb_number => irb_number, :irb_status => "Not Under IRB Purview")
  study.should be_valid
end

Given /^a study "([^\"]*)" with id "([^\"]*)" and irb_status "([^\"]*)"$/ do |title, irb_number, irb_status|
  Factory.create(:fake_study, :title => title, :name => title, :irb_number => irb_number, :irb_status => irb_status)
end

Given /^a READONLY study "([^\"]*)" with id "([^\"]*)" and irb_status "([^\"]*)"$/ do |title, irb_number, irb_status|
  Factory.create(:fake_study, :title => title, :name => title, :irb_number => irb_number, :irb_status => irb_status, :read_only => true)
end

Given /^I log in as "([^\"]*)" on study "([^\"]*)"$/ do |netid, irb_number|
  Given %("#{netid}" is on study "#{irb_number}")
  visit "/login"
  fill_in :username, :with => netid
  fill_in :password, :with => "secret"
  click_button "Log in"
end

Then /^"([^"]*)" should have (\d+) subjects$/ do |netid, num|
  Subject.with_user(netid).count.should == num.to_i
end


# Given /^I log in as admin "([^\"]*)" with password "([^\"]*)"$/ do |netid, password|
#   user = Factory.create(:user, {:netid => netid})
#   user.should be_valid
#   User.stub!(:find_by_id).and_return(user)
#   User.stub!(:authenticate).and_return{|n,p| p == password ? user : nil }
#   user.stub!(:admin?).and_return(true)
#   Given %(I log in as "#{name}" with password "#{password}")
# end

Given /^"([^\"]*)" is not authorized on any studies$/ do |netid|
  Role.find_all_by_netid(netid).should == []
end