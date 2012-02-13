Feature: GI Diaries
  In order to run the PPI non-responder study
  As a coordinator
  I want upload data from iPods and see the results in eCapture

  Background:
    Given a study "PPI non-responder" with id "STU00039540" and irb_status "Approved"
    And a the GI Diaries form on "STU00039540"
    
  Scenario: An unauthenticated user can upload a JSON response set
    Given I upload a JSON response set for case "E314159"
    Then I should receive a JSON success with message "Created case and GI Diaries form for case E314159"

  Scenario: An unauthenticated user can see errors
    Given I upload a JSON response set for case ""
    Then I should receive a JSON error "No case number provided"

  Scenario: An unauthenticated user can see errors
    Given I upload a blank JSON response set for case "E314159"
    Then I should receive a JSON error "No responses provided"

  Scenario: A coordinator can view uploaded response sets
    Given I log in as "usergey" on study "STU00039540"
    And I go to the study page for id "STU00039540"
    And I navigate to the "subjects" tab
    And I add a case number "E314159" with "Consented" on "03/01/2012"
    Given I upload a JSON response set for case "E314159"
    Then I should receive a JSON success with message "Created GI Diaries form for case E314159"
    And I go to the study page for id "STU00039540"
    And I navigate to the "subjects" tab
    And I navigate to the detail page for case "E314159"
    Then I should see "GI Diaries"

  Scenario: A coordinator can view duplicate uploaded response sets
    Given I log in as "usergey" on study "STU00039540"
    Given I upload a JSON response set for case "E314159"
    Then I should receive a JSON success with message "Created case and GI Diaries form for case E314159"
    Given I upload a JSON response set for case "E314159"
    Then I should receive a JSON success with message "Created GI Diaries form for case E314159"
    And I go to the study page for id "STU00039540"
    And I navigate to the "subjects" tab
    And I navigate to the detail page for case "E314159"
    Then I should see "GI Diaries"