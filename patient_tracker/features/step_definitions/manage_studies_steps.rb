require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^a study "([^\"]*)" with id "([^\"]*)" and status "([^\"]*)"$/ do |title, id, status|
  Factory.create(:fake_study, :title => title, :irb_number => id, :status => status)
end

Given /^I log in as "([^\"]*)"$/ do |name|
  Given "a user \"#{name}\" with password \"314159\""
  Given "\"#{name}\" has access to study id \"314\""
  Given "I log in as \"#{name}\" with password \"314159\""
end

When /^I search for study "([^\"]*)"$/ do |id|
  fill_in "study_id", :with => id
  click_button "Find"
end

Given /^a user "([^\"]*)" named "([^\"]*)" "([^\"]*)"$/ do |netid, fn, ln|
  user = Factory.create(:user, {:netid => netid, :first_name => fn, :last_name => ln})
end

