Feature: Manage studies
  In order to manage studies
  As a coordinator
  I want find a study and view detailed information

  Background:
    Given I log in as "pi"
      
  Scenario: A random user can search for studies (with study id)
    Given a study "Vitamin C and concentration" with id "0012345" and status "Approved"
    When I go to the dashboard
    And I search for study "0012345"
    Then I should see "Vitamin C and concentration"

  Scenario: A random user can search for studies (with keyword in title/short title)
    Given a study "Vitamin C and concentration" with id "0012345" and status "Approved"
    When I go to the dashboard
    And I search for study "Vitamin C"
    Then I should see "Vitamin C and concentration"
    
  Scenario: A random user can search for studies (fail) and get redirected
    When I go to the dashboard
    And I search for study "90210"
    Then I should see "0 studies found"
    And I should be on the search page

  Scenario: A random user can view overview details on a study, including IRB status
    Given a study "Vitamin C and concentration" with id "0012345" and status "Approved"
    When I go to the study page for id "0012345"
    Then I should see "Vitamin C and concentration"
    And I should see "Approved"

  Scenario: A random user cannot see study menu
    Given a study "Vitamin C and concentration" with id "0012345" and status "Approved"
    When I go to the study page for id "0012345"
    Then I should not see "Subject Imports"
    
  Scenario: A random user can view contact information for other users (click on name, get a popup)
    Given a user "suzq" named "Sue Z" "Quou"
    And "suzq" has access to study id "45234"
    When I go to the study page for id "45234"
    Then "Sue Z Quou" should be a link

  Scenario: A coordinator can view all details on their studies (all tabs on study menu)
    And a study "Vitamin D and Depression" with id "45234" and status "Approved"
    And "pi" has access to study id "45234"
    When I go to the study page for id "45234"
    Then I should see "Subject Imports"
  
  Scenario: A coordinator can view all personnel that have access on a study
    Given a user "suzq" named "Sue Z" "Quou"
    And "pi" has access to study id "45234"
    And "suzq" has access to study id "45234"
    When I go to the study page for id "45234"
    Then I should see "Sue Z Quou"
  
  Scenario: A coordinator can view all subjects they have access to on a study
    Given "pi" has access to study id "45234"
    And the study "45234" has the following subjects
      | first_name | last_name |
      | Marge      | Innovera  |
      | Picop N    | Dropov    |
    When I go to the study page for id "45234"
    Then I should see "Marge Innovera"
    And I should see "Picop N Dropov"
  
  Scenario: A coordinator can view all accrual information on a study
    Given "pi" has access to study id "45234"
    And the study "45234" has the following subjects
      | first_name | last_name |
      | Marge      | Innovera  |
      | Picop N    | Dropov    |
      | Dewey      | Cheetham  |
    When I go to the study page for id "45234"
    Then I should see "3 subjects "

  Scenario: A coordinator can view all imports made to a study they have access to
    Given "pi" has access to study id "45234"
    And the study "45234" has an upload by "pi"
    When I go to the study page for id "45234"
    And I follow "Subject Imports"
    Then I should see "pi"
