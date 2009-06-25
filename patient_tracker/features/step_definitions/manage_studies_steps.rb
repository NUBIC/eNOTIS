require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^a study "([^\"]*)" with id "([^\"]*)"$/ do |title, id|
  Factory.create(:fake_study, :title => title, :irb_number => id)
end