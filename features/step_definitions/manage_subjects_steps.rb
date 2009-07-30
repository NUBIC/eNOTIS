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

Given /^subject "([^\"]*)" is consented on study "([^\"]*)"$/ do |mrn, irb_number|
  Factory(:involvement, :subject => Subject.find_by_mrn(mrn), :study => Study.find_by_irb_number(irb_number))
  Factory(:involvement_event, :event_type => DictionaryTerm.find_by_term("Consented"))
end

Then /^I should see that subject "([^\"]*)" is not synced$/ do |mrn|
  response.should have_tag("tr") do |tr|
    tr.should contain(Subject.find_by_mrn(mrn).name)
    with_tag("a") do |a|
      a.should contain("Sync")
    end
  end
end

When /^I follow "Add Event" for "([^\"]*)"$/ do |mrn|
  click_link("add_event_#{Subject.find_by_mrn(mrn).id}")
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
