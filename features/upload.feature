Feature: Upload subjects
  In order to update a study
  As a coordinator
  I want to add subjects to a study

  Background:
    And a study "Vitamin C and concentration" with id "STU001248" and irb_status "Approved"
    Given I log in as "usergey" on study "STU001248"

  Scenario: A coordinator can upload a subject list from a file to the study
    When I go to the study page for id "STU001248"
    And I navigate to the "subjects" tab
    And I upload the "good.csv" file
    Then I should see "7 subjects created"
  
  Scenario: A coordinator can upload an invalid file and get a real error message
    When I go to the study page for id "STU001248"
    And I navigate to the "subjects" tab
    And I upload the "excel.xls" file
    Then I should see "Oops."

  Scenario: A coordinator can upload an invalid file and get a real error message
    When I go to the study page for id "STU001248"
    And I navigate to the "subjects" tab
    And I upload the "excel.xlsx" file
    Then I should see "Oops."

  Scenario: A coordinator can upload a file with humanized headings successfully
    When I go to the study page for id "STU001248"
    And I navigate to the "subjects" tab
    And I upload the "humanized_headings.csv" file
    Then I should see "1 subjects created"

  Scenario: A coordinator can upload a file with approximate terms
    When I go to the study page for id "STU001248"
    And I navigate to the "subjects" tab
    And I upload the "forgiving_terms.csv" file
    Then I should see "5 subjects created"

  Scenario: A coordinator can upload a file an overzealous "unknown" file and get a real error message
    When I go to the study page for id "STU001248"
    And I navigate to the "subjects" tab
    And I upload the "overzealous_unknowns.csv" file
    Then I should see "subjects created"

  Scenario: A coordinator can upload blank or too big file and get a real error message
    When I go to the study page for id "STU001248"
    And I navigate to the "subjects" tab
    And I upload a blank file
    Then I should see "Oops. Please upload a CSV"
