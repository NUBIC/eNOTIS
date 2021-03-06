Feature: Manage studies
  In order to manage studies
  As a coordinator
  I want find a study and view detailed information

  Background:
    Given a study "Vitamin C and concentration" with id "STU001248" and irb_status "Approved"
    Given I log in as "usergey" on study "STU001248"

  Scenario: A random user cannot view a study page
    Given a study "Vitamin E and exertion" with id "STU001249" and irb_status "Approved"
    When I go to the study page for id "STU001249"
    Then I should be redirected to the studies page
    And I should see "Access Denied"

  Scenario: A coordinator can view all subjects they have access to on a study
    Given the study "STU001248" has the following subjects
    | first_name | last_name |
    | Marge      | Innovera  |
    | Picop N    | Dropov    |
    | Dewey      | Cheetham  |
    When I go to the study page for id "STU001248"
    Then I should see "3"
    And I follow "subjects"
    And I should see "Innovera"
    And I should see "Dropov"

  Scenario: A coordinator can view a study with many subjects in a reasonable time
    Given the study "STU001248" has 300 subjects
     When I am concerned with performance
      And I go to the study page for id "STU001248"
     Then I should wait less than 4 seconds

  Scenario: A coordinator can view all imports made to a study they have access to
    Given the study "STU001248" has an upload by "pi"
    When I go to the study page for id "STU001248"
    And I follow "subjects"
    And I follow "Import"
    Then I should see "By"
    And I should see "Original"

  Scenario: A user will be gracefully redirected to the studies page when accessing a bogus study
    Given a study "Vitamin E and exertion" with id "STU001249" and irb_status "Approved"
    When I go to the study page for id "werewolf"
    Then I should be redirected to the studies page

  Scenario: A coordinator can download all subjects on a study
    Given the study "STU001248" has the following subjects
    | first_name | last_name |
    | Marge      | Innovera  |
    When I go to the study page for id "STU001248"
    And I export a csv of subjects
    Then I should see "Marge"


