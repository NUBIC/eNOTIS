Given /^I upload a JSON response set for case "([^"]*)"$/ do |case_number|
  path = gi_diaries_path
  json_string = '{ 
    "case_number": "' + case_number + '",
    "response_sets": [
      {
        "survey": "morning",
        "symptoms": "none",
        "severity": "",
        "sleep": "",
        "antacids": "0",
        "started_at": "2012-02-08 09:00:00",
        "completed_at": "2012-02-08 09:01:01"
      },
      {
        "survey": "evening",
        "symptoms": "none",
        "severity": "",
        "antacids": "0",
        "started_at": "2012-02-08 21:00:00",
        "completed_at": "2012-02-08 21:01:01"
      }
    ]
  }'
  post(path, json_string, {"CONTENT_TYPE" => "application/json"})
end

Then /^I should receive a JSON success with message "([^"]*)"$/ do |message|
  @response.body.should == '{"status":"success","message":"' + message + '"}'
end

Then /^I should receive a JSON error "([^"]*)"$/ do |message|
  @response.body.should == '{"status":"failure","message":"' + message + '"}'
end

Given /^I upload a blank JSON response set for case "([^"]*)"$/ do |case_number|
  path = gi_diaries_path
  json_string = '{ 
    "case_number": "'+ case_number + '",
    "response_sets": []
  }'
  post(path, json_string, {"CONTENT_TYPE" => "application/json"})
  
end
Given /^a the GI Diaries form on "([^"]*)"$/ do |irb_number|
  survey = 'survey "GI Diaries", :irb_number=>"' + irb_number + '" do
    section "Diary" do
      repeater "Morning" do
        q_morning_symptoms "What symptoms did you have last night?", :pick => :one
        a "none"
        a "heartburn"
        a "regurgitation"
        a "both"

        q_morning_severity "How severe were your symptoms?", :pick => :one
        a "mild"
        a "moderate"
        a "severe"

        q_morning_sleep "Did symptoms interfere with your sleep?", :pick => :one
        a "yes"
        a "no"

        q_morning_antacids "How many times did you take antacids?"
        a :integer
      end
      repeater "Evening" do
        q_evening_symptoms "What symptoms did you have last night?", :pick => :one
        a "none"
        a "heartburn"
        a "regurgitation"
        a "both"

        q_evening_severity "How severe were your symptoms?", :pick => :one
        a "mild"
        a "moderate"
        a "severe"

        q_evening_antacids "How many times did you take antacids?"
        a :integer
      end
    end
  end'
  Surveyor::Parser.parse(survey)
end

Then /^I should see "([^"]*)" for case "([^"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end