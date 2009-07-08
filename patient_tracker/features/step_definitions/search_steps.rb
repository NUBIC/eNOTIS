require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

When /^I search for "([^\"]*)"$/ do |query|
  fill_in :query, :with => query
  click_button :search
end
