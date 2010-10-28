require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

When /^I add a subject "([^\"]*)" "([^\"]*)" with "([^\"]*)" on "([^\"]*)"$/ do |first, last, event, date|
  When %(I follow "Add")
  fill_in "First name", :with => first
  fill_in "Last name", :with => last
  fill_in "Birth date", :with => "8/7/65"
  select "Female", :from => "Gender"
  select "Not Hispanic or Latino", :from => "Ethnicity"
  check "Asian"#, :from => "Race"
  select event, :from => "Activity"
  fill_in "On", :with => date
  click_button "Save"
end

When /^I add a subject "([^"]*)" "([^"]*)" with "([^"]*)" on "([^"]*)" and MRN "([^\"]*)"$/ do |first, last, event, date, mrn|
  When %(I follow "Add")
  fill_in "First name", :with => first
  fill_in "Last name", :with => last
  fill_in "Birth date", :with => "8/7/65"
  fill_in "MRN", :with => mrn
  select "Female", :from => "Gender"
  select "Not Hispanic or Latino", :from => "Ethnicity"
  check "Asian"#, :from => "Race"
  select event, :from => "Activity"
  fill_in "On", :with => date
  click_button "Save"
end

When /^I add a case number "([^\"]*)" with "([^\"]*)" on "([^\"]*)"$/ do |case_number, event, date|
  When %(I follow "Add")
  fill_in "Case number", :with => case_number
  fill_in "Birth date", :with => "8/7/65"
  select "Female", :from => "Gender"
  select "Not Hispanic or Latino", :from => "Ethnicity"
  check "Asian"#, :from => "Race"
  select event, :from => "Activity"
  fill_in "On", :with => date
  click_button "Save"
end

Then /^I add edit subject "([^\"]*)" "([^\"]*)" with 2nd event "([^\"]*)" on "([^\"]*)"$/ do |first, last, event, date|
  sid = Subject.find_by_first_name_and_last_name(first, last).id
  within ".subject_#{sid}" do |scope|
    scope.click_link "Edit"
  end
  select event, :from => :involvement_involvement_events_attributes_1_event
  fill_in :involvement_involvement_events_attributes_1_occurred_on, :with => date
  click_button "Save"
end

Then /^I remove subject "([^"]*)" "([^"]*)"$/ do |first, last|
  sid = Subject.find_by_first_name_and_last_name(first, last).id
  within ".subject_#{sid}" do |scope|
    scope.click_link "Delete"
  end
end

Given /^the readonly study "([^\"]*)" has the following subjects$/ do |id, table|
  ResqueSpec.reset!
  study = Study.find_by_irb_number(id)
  table.hashes.each do |hash|
    _involvement = Factory(:involvement, :study => study, :subject => Factory(:fake_subject, hash))
    EmpiWorker.should_not have_queued(_involvement.id)
  end
end

Given /^the study "([^\"]*)" has the following subjects$/ do |id, table|
  ResqueSpec.reset!
  study = Study.find_by_irb_number(id)
  table.hashes.each do |hash|
    _involvement = Factory(:involvement, :study => study, :subject => Factory(:fake_subject, hash))
    EmpiWorker.should have_queued(_involvement.id)
  end
end

Given /^the study "([^\"]*)" has an upload by "([^\"]*)"$/ do |id, netid|
  Factory.create(:study_upload, :study_id => Study.find_by_irb_number(id).id, :user_id => User.find_by_netid(netid).id)
end

Given /^a subject with mrn "([^\"]*)"$/ do |mrn|
 Factory(:subject, :mrn => mrn)
end

Given /^subject "([^\"]*)" has event "([^\"]*)" on study "([^\"]*)"$/ do |mrn, term, irb_number|
  unless involvement = Involvement.find_by_subject_id_and_study_id(Subject.find_by_mrn(mrn), Study.find_by_irb_number(irb_number))
    involvement = Factory(:involvement, :subject => Subject.find_by_mrn(mrn), :study => Study.find_by_irb_number(irb_number))
  end
  Factory(:involvement_event, :involvement => involvement, :event => term)
end

Then /^subject "([^\"]*)" should have (\d+) events? on study "([^\"]*)"$/ do |mrn, x, irb_number|
  subject_id = Subject.find_by_mrn(mrn).id
  study_id = Study.find_by_irb_number(irb_number).id
  Involvement.find_by_subject_id_and_study_id(subject_id, study_id).involvement_events.should have(x.to_i).involvement_events
end

Then /^subject "([^\"]*)" "([^\"]*)" should have (\d+) events? on study "([^\"]*)"$/ do |first, last, x, irb_number|
  subject_id = Subject.find_by_first_name_and_last_name(first, last).id
  study_id = Study.find_by_irb_number(irb_number).id
  Involvement.find_by_subject_id_and_study_id(subject_id, study_id).involvement_events.should have(x.to_i).involvement_events
end


Then /^subject "([^\"]*)" should not be involved with study "([^\"]*)"$/ do |mrn, irb_number|
  Involvement.find_by_subject_id_and_study_id(Subject.find_by_mrn(mrn), Study.find_by_irb_number(irb_number)).should be_blank
end

When /^I upload the "([^"]*)" file$/ do |name|
  click_link("Import")
  attach_file(:file, File.join(RAILS_ROOT, 'spec', 'uploads', name))  
  click_button "Upload"
end

When /^I export a csv of subjects$/ do
  click_link("Export")
  select "CSV", :from=>"File Format"  
  click_button("Export Data")
end



