require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

When /^I search for "([^\"]*)"$/ do |query|
  fill_in :query, :with => query
  click_button :search
end

Then /^I should see title "([^\"]*)"$/ do |title|
  response.should have_xpath("//*[@title='#{title}']")
end

Then /^"([^\"]*)" should be a link$/ do |text|
  response.should have_tag("a", :text => text)
end

Then /^I should see an image with alt "([^\"]*)"$/ do |alt_text|
 response.should have_xpath("//img[@alt='#{alt_text}']")
end

Then /^I should be redirected to (.+?)$/ do |page_name|
  request.headers['HTTP_REFERER'].should_not be_nil
  request.headers['HTTP_REFERER'].should_not == request.request_uri

  Then "I should be on #{page_name}"
end

When /^I visit the roles page for "([^"]*)"$/ do |netid|
  visit "/roles/#{netid}"
end

When /^I export a PI study report for "([^"]*)"$/ do |year|
  When "I go to the hub page"
  select year, :from => "Year"
  click_button("Export PI Study Report")
end

Then /^there should be (\d+) activit(?:y|ies) with$/ do |num, table|
  Activity.count.should == num.to_i
  table.hashes.each do |hash|
    Activity.first(:conditions => hash).should_not be_nil
  end
end

Then /^there should be (\d+) versions with$/ do |num, table|
  # puts Version.all.map(&:inspect).join("\n")
  Version.count.should == num.to_i
  table.hashes.each do |hash|
    Version.first(:conditions => hash).should_not be_nil
  end
end
