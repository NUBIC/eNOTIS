require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^a study "([^\"]*)" with id "([^\"]*)" and status "([^\"]*)"$/ do |title, id, status|
  @study = Factory.create(:fake_study, :title => title, :irb_number => id, :status => status)
end