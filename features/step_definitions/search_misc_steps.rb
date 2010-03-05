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