Given /^the following subject_study_listings:$/ do |subject_study_listings|
  SubjectStudyListing.create!(subject_study_listings.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) subject_study_listing$/ do |pos|
  visit subject_study_listings_url
  within("table > tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following subject_study_listings:$/ do |subject_study_listings|
  subject_study_listings.rows.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("table > tr:nth-child(#{i+2}) > td:nth-child(#{j+1})") { |td|
        td.inner_text.should == cell
      }
    end
  end
end
