Feature: Manage studies
  In order to manage studies
  As a coordinator
  I want find a study and view detailed information
  
  Background:
    Given a user "pi" with password "314159"
    And a study "The effects of Vitamin A on concentration" with id "0012345"
  @focus

  Scenario: A random user can search for studies (with study id or keyword in title/short title)
    When I log in as "pi" with password "314159"
    And I go to the dashboard
    And I fill in "study_id" with "0012345"
    And I press "Find"
    Then I should see "The effects of Vitamin A on concentration"

  Scenario: A random user can search for studies (fail) and get redirected
    When I log in as "pi" with password "314159"
    And I go to the dashboard
    And I fill in "study_id" with "999"
    And I press "Find"
    Then I should see "No studies found"
    And I should be on the dashbaord
        
  Scenario: A random user can view overview details on a study, including IRB status
    Given
    When
    Then
    
  Scenario: A random user cannot see study menu
    Given
    When
    Then
    
  Scenario: A random user can view contact information for other users (click on name, get a popup)
    Given
    When
    Then

  Scenario: A coordinator can view all details on their studies (all tabs on study menu)
    Given
    When
    Then
  
  Scenario: A coordinator can view all personnel that have access on a study
    Given
    When
    Then
  
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
  
  
