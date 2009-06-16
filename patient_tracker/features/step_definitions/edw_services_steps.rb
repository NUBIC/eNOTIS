Given /^there is a subject with MRN ([a-zA-Z0-9]+) named ([\w\s]+)$/ do
  pending
end

When /^I find a subject by MRN ([a-zA-Z0-9]+)$/ do |mrn|
  Subject.find_by_mrn(mrn)
end

Then /^I should get a subject named ([\w\s]+)$/ do |name|
  pending
end

Given /^there is a subject named ([\w\s]+) with birthday ([0-9\/\-\. ]+) with address ([\w\s]+)$/ do
  pending
end

When /^I find a subject by name ([\w\s]+) and birthday ([0-9\/\-\. ]+)$/ do
  pending
end

Then /^I should get a subject with address ([\w\s]+)$/ do
  pending
end
