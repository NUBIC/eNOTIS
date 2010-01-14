Feature: Manage subjects
  In order to update a study
  As a coordinator
  I want to add subjects to a study

  Background:
    Given I log in as "pi"
    And a study "Vitamin C and concentration" with id "1248C" and status "Approved"
    And "pi" has access to study id "1248C"

  Scenario: A coordinator can upload a subject list from a file to the study
    When I go to the study page for id "1248C"
    And I upload a file with valid data for 3 subjects
    Then I should see "Subjects (3)"