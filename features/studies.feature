Feature: Manage studies
  In order to manage studies
  As a coordinator
  I want find a study and view detailed information

  Background:
    Given I log in as "pi"
    And a study "Vitamin C and concentration" with id "1248C" and status "Approved"
    And "pi" has access to study id "1248C"
      
  Scenario: A random user can view overview details on a study, including IRB status
    
  Scenario: A random user cannot a study page
    Given a study "Vitamin E and exertion" with id "1248E" and status "Approved"
    When I go to the study page for id "1248E"
    Then I should be redirected to the homepage
    
  Scenario: A random user can view contact information for other coordinators
    Given a user "suzq" named "Sue Z" "Quou"
    And "suzq" has access to study id "1248C"
    When I go to the study page for id "1248C"
    Then "Sue Z Quou" should be a link

  Scenario: A coordinator can view all subjects they have access to on a study
    Given the study "1248C" has the following subjects
    | first_name | last_name |
    | Marge      | Innovera  |
    | Picop N    | Dropov    |
    | Dewey      | Cheetham  |
    When I go to the study page for id "1248C"
    Then I should see "Subjects (3)"
    And I should see "Innovera"
    And I should see "Dropov"

  Scenario: A coordinator can view all imports made to a study they have access to
    Given the study "1248C" has an upload by "pi"
    When I go to the study page for id "1248C"
    And I follow "Import"
    Then I should see "pi"
