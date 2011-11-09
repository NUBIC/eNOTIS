Feature: View Readonly Studies
  In order to view imported studies
  As a coordinator
  I want to find a study and view detailed information but not edit it

  Background:
    Given a READONLY study "Vitamin C and concentration" with id "STU009248" and irb_status "Approved"
    Given I log in as "usergey" on study "STU009248"

  Scenario: A study I manage is read-only because it's data is imported from NOTIS
    Given the readonly study "STU009248" has the following subjects
    | first_name | last_name |
    | Bob        | Jones     |
    When I go to the study page for id "STU009248"
    And I navigate to the "subjects" tab
    Then I should not see "Add" within "#pane_actions"
    And I should not see "Bulk Import" within "#pane_actions"
    And I follow "Detail"
    And I should not see "Edit" within "#pane_actions"
    #And I should see "View" within "#subjects"
    #And I should see "Readonly" within ".study_message"

