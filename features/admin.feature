Feature: Developer admin access
  In order to help users
  As a developer
  I want to be able see user activity

  Scenario: A normal user should not be able to visit the hub
    Given I log in as "gns144" with password "stjames" on study "STU00144"
    And I go to the hub page
    Then I should be on the homepage

  Scenario: An admin user should be able to see active users and studies
    Given I log in as admin "admin" with password "secret"
    And I go to the hub page
    Then I should be on the hub page
    And I should see "active users"
    And I should see "active studies"
  
  Scenario: An admin user should be able to see study uploads
    Given I log in as admin "admin" with password "secret"
    And a study "Vitamin C and concentration" with id "STU001248" and irb_status "Approved"
    When I go to the study page for id "STU001248"
    And I upload a file with valid data for 7 subjects    
    And I go to the hub page
    Then I should be on the hub page
    And I should see "1 recent upload"
    
  