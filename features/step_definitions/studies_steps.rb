require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^a study "([^\"]*)" with id "([^\"]*)" and irb_status "([^\"]*)"$/ do |title, id, status|
  Factory.create(:fake_study, :title => title, :name => title, :irb_number => id, :irb_status => status)
end

Given /^a user "([^\"]*)" named "([^\"]*)" "([^\"]*)"$/ do |netid, fn, ln|
  Factory.create(:user, {:netid => netid, :first_name => fn, :last_name => ln})
end

Then /^"([^\"]*)" should be a link$/ do |text|
  response.should have_tag("a", :content => text)
end

Given /^the study "([^\"]*)" has the following subjects$/ do |id, table|
  study = Study.find_by_irb_number(id)
  table.hashes.each do |hash|
    Factory(:involvement, :study => study, :subject => Factory(:fake_subject, hash))
  end
end

Given /^the study "([^\"]*)" has an upload by "([^\"]*)"$/ do |id, netid|
  Factory.create(:study_upload, :study_id => Study.find_by_irb_number(id).id, :user_id => User.find_by_netid(netid).id)
end
