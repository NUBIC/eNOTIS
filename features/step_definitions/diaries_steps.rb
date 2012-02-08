Given /^I upload a JSON response set for case "([^"]*)"$/ do |case_number|
  path = gi_diaries_path
  json_string = '{ 
    "case_number": "E314159",
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

Given /^I upload an invalid JSON response set for case "([^"]*)"$/ do |case_number|
  path = gi_diaries_path
  json_string = '{ 
    "case_number": ""
  }'
  post(path, json_string, {"CONTENT_TYPE" => "application/json"})
end

Then /^I should receive a JSON success$/ do
  @response.body.should == '{"status":"success"}'
end

Then /^I should receive a JSON error$/ do
  @response.body.should == '{"status":"failure"}'
end

Then /^I should see "([^"]*)" for case "([^"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end