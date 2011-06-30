require 'time'

When /^I am concerned with performance$/ do
  @start_time = Time.now
end

Then /^I should wait less than (\d+(.\d+)?) seconds?$/ do |elapsed, _|
  (Time.now - @start_time).should < elapsed.to_f
end
