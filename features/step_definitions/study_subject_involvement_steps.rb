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
  fill_in "NMH MRN", :with => mrn
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

When /^I add full information on "([^"]*)" "([^"]*)" with "([^"]*)" on "([^"]*)"$/ do |first, last, event, date|
  When %(I follow "Add")
  fill_in "NMH MRN", :with => "G10203040"
  fill_in "NMFF MRN", :with => "Q0293u2"
  fill_in "RIC MRN", :with => "J23023a"
  fill_in "First name", :with => first
  fill_in "Middle", :with => "Q"
  fill_in "Last name", :with => last
  fill_in "Suffix", :with => "Jr."
  fill_in "Birth date", :with => "8/7/65"
  fill_in "Death date", :with => "8/7/2010"

  fill_in "Address", :with => "3400 E. Wilson"
  fill_in "Line 2", :with => "Crib tower"
  fill_in "City", :with => "Chicago"
  fill_in "State", :with => "IL"
  fill_in "Zip", :with => "60640"
  fill_in "E-mail", :with => "x@y.com"
  fill_in "Home phone", :with => "312-512-3456"
  fill_in "Work", :with => "(773)-678-9012"
  fill_in "Cell", :with => "847.654.3210"

  select "Male", :from => "Gender"
  select "Not Hispanic or Latino", :from => "Ethnicity"
  check "Asian"#, :from => "Race"
  check "White"
  select event, :from => "Activity"
  fill_in "On", :with => date
  click_button "Save"
end


Then /^I add edit subject "([^\"]*)" "([^\"]*)" with 2nd event "([^\"]*)" on "([^\"]*)"$/ do |first, last, event, date|
  sid = Subject.find_by_first_name_and_last_name(first, last).id
  within ".subject_#{sid}" do |scope|
    scope.click_link "Detail"
  end
  within "#involvement_events" do |scope|
    scope.click_link "Add"
  end
  select event, :from => :involvement_event_event_type_id
  fill_in :involvement_event_occurred_on, :with => date
  click_button "create"
end

Then /^I navigate to the edit page for subject "([^\"]*)" "([^\"]*)"$/ do |first,last|
  sid = Subject.find_by_first_name_and_last_name(first, last).id
  within ".subject_#{sid}" do |scope|
    scope.click_link "Detail"
  end
  click_link "Edit"

end

Then /^I remove subject "([^"]*)" "([^"]*)"$/ do |first, last|
  sid = Subject.find_by_first_name_and_last_name(first, last).id
  within ".subject_#{sid}" do |scope|
    scope.click_link "Detail"
  end
  within "#involvement_demographics" do |scope|
    scope.click_link "Delete"
  end
end

Given /^the readonly study "([^\"]*)" has the following subjects$/ do |id, table|
  study = Study.find_by_irb_number(id)
  table.hashes.each do |hash|
    _involvement = Factory(:involvement, :study => study, :subject => Factory(:fake_subject, hash))
    #EmpiWorker.should_not have_queued(_involvement.id)
  end
end

Given /^the study "([^\"]*)" has the following subjects$/ do |id, table|
  study = Study.find_by_irb_number(id)
  table.hashes.each do |hash|
    _involvement = Factory(:involvement, :study => study, :subject => Factory(:fake_subject, hash))
  end
end

Given /^the study "([^\"]*)" has (\d+) subjects$/ do |id, ct|
  study = Study.find_by_irb_number(id)
  (ct.to_i - study.involvements.size).times do
    Factory(:involvement, :study => study, :subject => Factory(:fake_subject))
  end
end

Given /^the study "([^\"]*)" has an upload by "([^\"]*)"$/ do |id, netid|
  Factory.create(:study_upload, :study_id => Study.find_by_irb_number(id).id, :netid => netid)
end

Given /^a subject with mrn "([^\"]*)"$/ do |mrn|
 Factory(:subject, :nmff_mrn => mrn)
end

Given /^subject "([^\"]*)" has event "([^\"]*)" on study "([^\"]*)"$/ do |mrn, term, irb_number|
  study = Study.find_by_irb_number(irb_number)
  unless involvement = Involvement.find_by_subject_id_and_study_id(Subject.find_by_nmff_mrn(mrn), study)
    involvement = Factory(:involvement, :subject => Subject.find_by_nmff_mrn(mrn), :study => study)
  end
  Factory(:involvement_event, :involvement => involvement, :event => term)
end

Then /^subject "([^\"]*)" should have (\d+) events? on study "([^\"]*)"$/ do |mrn, x, irb_number|
  subject_id = Subject.find_by_nmff_mrn(mrn).id
  study_id = Study.find_by_irb_number(irb_number).id
  Involvement.find_by_subject_id_and_study_id(subject_id, study_id).involvement_events.should have(x.to_i).involvement_events
end

Then /^subject "([^\"]*)" "([^\"]*)" should have (\d+) events? on study "([^\"]*)"$/ do |first, last, x, irb_number|
  subject_id = Subject.find_by_first_name_and_last_name(first, last).id
  study_id = Study.find_by_irb_number(irb_number).id
  Involvement.find_by_subject_id_and_study_id(subject_id, study_id).involvement_events.should have(x.to_i).involvement_events
end


Then /^subject "([^\"]*)" should not be involved with study "([^\"]*)"$/ do |mrn, irb_number|
  Involvement.find_by_subject_id_and_study_id(Subject.find_by_nmff_mrn(mrn), Study.find_by_irb_number(irb_number)).should be_blank
end

When /^I navigate to the "([^\"]*)" tab$/ do |tab|
  click_link(tab)
end
  

When /^I upload the "([^"]*)" file$/ do |name|
  click_link("Import")
  attach_file(:file, File.join(RAILS_ROOT, 'spec', 'uploads', name))
  click_button "Upload"
end

When /^I upload a blank file$/ do
  click_link("Import")
  click_button "Upload"
end


When /^I export a csv of subjects$/ do
  click_link("Export")
  select "CSV", :from=> :format
  click_button("Export Data")
end

Given /^the study "([^"]*)" has a subject accrued on "([^"]*)"$/ do |irb_number, date|
  study = Study.find_by_irb_number(irb_number) || Factory.create(:fake_study, :irb_number => irb_number, :irb_status => "Not Under IRB Purview")
  involvement = Factory(:involvement, :study => study)
  ie = Factory(:involvement_event, :occurred_on => date, :involvement => involvement)
  ie.event = "Consented"
  ie.save
end

When /^I export the NIH report$/ do
  click_link("NIH Inclusion Enrollment Report")
end

When /^I look up "([^"]*)" "([^"]*)"$/ do |type, mrn|
  Empi.stub!(:client).and_return(true)
  Empi.stub!(:get).and_return({:response => [{:first_name => "Frank", :last_name => "Costello"}]})
  visit empi_lookup_involvements_path({:involvement => {:subject_attributes => {type.to_sym => mrn}}})
end

Then /^I should see "([^"]*)" "([^"]*)" as a search result$/ do |fn, ln|
  within "#empi_results" do |scope|
    scope.should have_selector("input[value='#{fn}']")
  end
  within "#empi_results" do |scope|
    scope.should have_selector("input[value='#{ln}']")
  end
  
end

