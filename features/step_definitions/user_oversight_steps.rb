require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^"([^\"]*)" is not authorized on any studies$/ do |netid|
  Role.find_all_by_netid(netid).should == []
end

Given /^"([^"]*)" is an oversight user$/ do |netid|
  Bcsec.authority.find_user(netid).permit?(:oversight).should be_true
end


