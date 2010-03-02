require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^a study "([^\"]*)" with id "([^\"]*)" and irb_status "([^\"]*)"$/ do |title, id, status|
  Factory.create(:fake_study, :title => title, :name => title, :irb_number => id, :irb_status => status)
end

Given /^the study "([^\"]*)" has the following subjects$/ do |id, table|
  study = Study.find_by_irb_number(id)
  table.hashes.each do |hash|
    Factory(:involvement, :study => study, :subject => Factory(:fake_subject, hash))
  end
end

Given /^the study "([^\"]*)" has an upload by "([^\"]*)"$/ do |id, netid|
  Factory.create(:study_upload, :study_id => Study.find_by_irb_number(id).id, :user_id => User.find_by_netid(netid).id)
end

Given /^a subject with mrn "([^\"]*)"$/ do |mrn|
 Factory(:subject, :mrn => mrn)
end

Then /^I should see the add subject form$/ do
  response.should have_tag("form[action=?]", involvement_events_path) do
    with_tag("input[name=?]", "subject[mrn]")
    with_tag("input[name=?]", "subject[first_name]")
    with_tag("input[name=?]", "subject[last_name]")
    with_tag("input[name=?]", "subject[birth_date]")
  end
end

Given /^subject "([^\"]*)" is not synced$/ do |mrn|
  Subject.find_by_mrn(mrn).update_attributes(:synced_at => nil)
end

Given /^subject "([^\"]*)" has event "([^\"]*)" on study "([^\"]*)"$/ do |mrn, term, irb_number|
  unless involvement = Involvement.find_by_subject_id_and_study_id(Subject.find_by_mrn(mrn), Study.find_by_irb_number(irb_number))
    involvement = Factory(:involvement, :subject => Subject.find_by_mrn(mrn), :study => Study.find_by_irb_number(irb_number))
  end
  Factory(:involvement_event, :involvement => involvement, :event_type_id => DictionaryTerm.event_id(term))
end

Then /^subject "([^\"]*)" should have (\d+) events? on study "([^\"]*)"$/ do |mrn, x, irb_number|
  Involvement.find_by_subject_id_and_study_id(Subject.find_by_mrn(mrn), Study.find_by_irb_number(irb_number)).involvement_events.should have(x.to_i).involvement_events
end

Then /^subject "([^\"]*)" should not be involved with study "([^\"]*)"$/ do |mrn, irb_number|
  Involvement.find_by_subject_id_and_study_id(Subject.find_by_mrn(mrn), Study.find_by_irb_number(irb_number)).should be_blank
end

Then /^I should see the add event form$/ do
  response.should have_tag("form[action=?]", involvement_events_path) do
    with_tag("select[name=?]", "involvement_events[][event_type_id]")
    with_tag("input[name=?]", "involvement_events[][occurred_on]")
    with_tag("input[name=?]", "involvement_events[][note]")
  end
end

When /^I upload a file with valid data for 7 subjects$/ do  
  attach_file(:file, File.join(RAILS_ROOT, 'spec', 'uploads', 'good.csv'))  
  click_button "Upload"  
end
