Feature: Manage studies
  In order to manage studies
  As a coordinator
  I want find a study and view detailed information

  Background:
    Given I log in as "pi"
    And a study "Vitamin C and concentration" with id "STU001248" and irb_status "Approved"
    And "pi" has access to study id "STU001248"
      
  Scenario: A random user can view overview details on a study, including IRB irb_status
    
  Scenario: A random user cannot a study page
    Given a study "Vitamin E and exertion" with id "STU001249" and irb_status "Approved"
    When I go to the study page for id "STU001249"
    Then I should be redirected to the homepage
    
  Scenario: A random user can view contact information for other coordinators
    Given a user "suzq" named "Sue Z" "Quou"
    And "suzq" has access to study id "STU001250"
    When I go to the study page for id "STU001250"
    Then "Sue Z Quou" should be a link

  Scenario: A coordinator can view all subjects they have access to on a study
    Given the study "STU001248" has the following subjects
    | first_name | last_name |
    | Marge      | Innovera  |
    | Picop N    | Dropov    |
    | Dewey      | Cheetham  |
    When I go to the study page for id "STU001248"
    Then I should see "Subjects (3)"
    And I should see "Innovera"
    And I should see "Dropov"

  Scenario: A coordinator can view all imports made to a study they have access to
    Given the study "STU001248" has an upload by "pi"
    When I go to the study page for id "STU001248"
    And I follow "Import"
    Then I should see "pi"
