Feature: Manage studies
  In order to manage studies
  As a coordinator
  I want find a study and view detailed information

  Background:
    And a study "Vitamin C and concentration" with id "STU001248" and irb_status "Approved"
    Given I log in as "pi" with password "secret" on study "STU001248"
  
  Scenario: A random user cannot view a study page
    Given a study "Vitamin E and exertion" with id "STU001249" and irb_status "Approved"
    When I go to the study page for id "STU001249"
    Then I should be redirected to the homepage
    And I should see "You don't have access to study STU001249"
  
  Scenario: A random user can view contact information for other coordinators
  # Brian not interested in testing right now, not essential enough to put in db

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
    Then I should see "Importer"
    And I should see "Original"

  Scenario: A user will be gracefully redirected to the studies page when accessing a bogus study
    Given a study "Vitamin E and exertion" with id "STU001249" and irb_status "Approved"
    When I go to the study page for id "werewolf"
    Then I should be redirected to the studies page
  