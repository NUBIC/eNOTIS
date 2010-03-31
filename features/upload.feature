Feature: Upload subjects
  In order to update a study
  As a coordinator
  I want to add subjects to a study

  Background:
    And a study "Vitamin C and concentration" with id "STU001248" and irb_status "Approved"
    Given I log in as "pi" with password "secret" on study "STU001248"

  Scenario: A coordinator can upload a subject list from a file to the study
    When I go to the study page for id "STU001248"
    And I upload a file with valid data for 7 subjects
    And I go to the study page for id "STU001248"
    Then I should see "Subjects 7"

