require 'time'

When /^I am concerned with performance$/ do
  @start_time = Time.now
end

Then /^I should wait less than (\d+(.\d+)?) seconds?$/ do |elapsed, _|
  expected = elapsed.to_f
  if ENV['RAILS_ENV'] =~ /hudson/i
    expected = expected * 3
  end
  (Time.now - @start_time).should < expected
end
