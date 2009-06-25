
Feature: Manage studies
  In order to manage studies
  As a coordinator
  I want find a study and view detailed information

  Background:
    Given a study "Vitamin C and concentration" with id "0012345" and status "Approved"
    
  Scenario: A random user can search for studies (with study id or keyword in title/short title)
    Given I log in as "pi"
    When I go to the dashboard
    And I search for study "0012345"
    Then I should see "Vitamin C and concentration"

  Scenario: A random user can search for studies (fail) and get redirected
    Given I log in as "pi"
    When I go to the dashboard
    And I search for study "90210"
    Then I should see "No studies found"
    And I should be on the dashboard

  Scenario: A random user can view overview details on a study, including IRB status
    Given I log in as "pi"
    When I go to the study page for id "0012345"
    Then I should see "Vitamin C and concentration"
    And I should see "Approved"

  Scenario: A random user cannot see study menu
    Given I log in as "pi"
    When I go to the study page for id "0012345"
    Then I should not see "Status History"
    And I should not see "Study Documents"
    
  Scenario: A random user can view contact information for other users (click on name, get a popup)
    Given
    When
    Then

  Scenario: A coordinator can view all details on their studies (all tabs on study menu)
    Given I log in as "pi"
    And a study "Vitamin D and Depression" with id "45234" and status "Approved"
    And "pi" has access to study id "45234"
    When I go to the study page for id "45234"
    Then I should see "Status History"
    And I should see "Study Documents"
  
  Scenario: A coordinator can view all personnel that have access on a study
    Given I log in as "pi"
    And a user "suzq" named "Sue Z" "Quou"
    And "pi" has access to study id "45234"
    And "suzq" has access to study id "45234"
    When I go to the study page for id "45234"
    Then I should see "Sue Z Quou"
  
  Scenario: A coordinator can view all subjects they have access to on a study
    Given
    When
    Then
  
  Scenario: A coordinator can view all accrual information on a study
    Given
    When
    Then
  
  Scenario: A coordinator can view links to documents they have access to on a study
    Given
    When
    Then
  
  Scenario: A coordinator can view all imports made to a study they have access to
    Given
    When
    Then
  
  
