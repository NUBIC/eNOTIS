Given /^events, genders, and ethnicities are populated$/ do
  Factory(:dictionary_term, :term => "Male", :category => "Gender")
  Factory(:dictionary_term, :term => "Female", :category => "Gender")
  Factory(:dictionary_term, :term => "Screened", :category => "Event")
  Factory(:dictionary_term, :term => "Consented", :category => "Event")
  Factory(:dictionary_term, :term => "Randomized", :category => "Event")
  Factory(:dictionary_term, :term => "Withdrawn", :category => "Event")
  Factory(:dictionary_term, :term => "Hispanic or Latino", :category => "Ethnicity")
  Factory(:dictionary_term, :term => "Not Hispanic or Latino", :category => "Ethnicity")
  Factory(:dictionary_term, :term => "Asian", :category => "Race")
  Factory(:dictionary_term, :term => "White", :category => "Race")
end


Given /^a subject with mrn "([^\"]*)"$/ do |mrn|
 Factory(:subject, :mrn => mrn)
end

Then /^I should see the add subject form$/ do
  response.should have_tag("form[action=?]", involvement_events_path) do
    with_tag("input[name=?]", "subject[mrn]")
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
