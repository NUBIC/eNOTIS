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
  Factory(:involvement_event, :involvement => involvement, :event_type => DictionaryTerm.find_by_term(term))
end

Then /^I should see that subject "([^\"]*)" is not synced$/ do |mrn|
  response.should have_tag("tr") do |tr|
    tr.should contain(Subject.find_by_mrn(mrn).name)
    with_tag("a") do |a|
      a.should contain("Sync")
    end
  end
end

Then /^subject "([^\"]*)" should have (\d+) events? on study "([^\"]*)"$/ do |mrn, x, irb_number|
  Involvement.find_by_subject_id_and_study_id(Subject.find_by_mrn(mrn), Study.find_by_irb_number(irb_number)).involvement_events.should have(x.to_i).involvement_events
end

Then /^subject "([^\"]*)" should not be involved with study "([^\"]*)"$/ do |mrn, irb_number|
  Involvement.find_by_subject_id_and_study_id(Subject.find_by_mrn(mrn), Study.find_by_irb_number(irb_number)).should be_blank
end

When /^I follow "([^\"]*)" for "([^\"]*)" on the "([^\"]*)" tab$/ do |link, mrn, selector|
  within("\##{selector.downcase}") do
    within("\.subject_#{Subject.find_by_mrn(mrn).id}") do
      click_link(link)
    end
  end
end

Then /^I should see the add event form$/ do
  response.should have_tag("form[action=?]", involvement_events_path) do
    with_tag("select[name=?]", "involvement_event[event_type_id]")
    with_tag("input[name=?]", "involvement_event[occured_at]")
    with_tag("input[name=?]", "involvement_event[note]")
  end
end



# Given /^the following subject_registrations:$/ do |subject_registrations|
#   SubjectRegistration.create!(subject_registrations.hashes)
# end
# 
# When /^I delete the (\d+)(?:st|nd|rd|th) subject_registration$/ do |pos|
#   visit subject_registrations_url
#   within("table > tr:nth-child(#{pos.to_i+1})") do
#     click_link "Destroy"
#   end
# end
# 
# Then /^I should see the following subject_registrations:$/ do |subject_registrations|
#   subject_registrations.rows.each_with_index do |row, i|
#     row.each_with_index do |cell, j|
#       response.should have_selector("table > tr:nth-child(#{i+2}) > td:nth-child(#{j+1})") { |td|
#         td.inner_text.should == cell
#       }
#     end
#   end
# end
