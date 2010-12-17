Feature: Developer admin access
  In order to help users
  As a developer
  I want to be able see user activity

  Scenario: A normal user should not be able to visit the hub
    Given I log in as "usergey" on study "STU00144"
    And "usergey" is not an admin
    And I go to the hub page
    Then I should not see "back to eNOTIS"
    Then I should be on the studies page

  Scenario: An admin user should be able to visit the hub
    Given I log in as "adminnie" on study "STU00144"
    And I go to the hub page
    Then I should see "back to eNOTIS"    

  Scenario: An admin user should be able to see active users and studies
    Given I log in as "adminnie" on study "STU00144"
    And I go to the hub page
    Then I should be on the hub page
    And I should see "active users"
    And I should see "active (non NOTIS) studies"
  
  Scenario: An admin user should be able to see study uploads
    Given I log in as "adminnie" on study "STU00144"
    And a study "Vitamin C and concentration" with id "STU001248" and irb_status "Approved"
    When I go to the study page for id "STU001248"
    And I upload the "good.csv" file
    And I go to the hub page
    Then I should be on the hub page
    And I should see "1 recent upload"
    And I should see "Consented: 7, Completed: 3, Withdrawn: 2"
  
  Scenario: An admin user should be able to see active users and studies
    Given I log in as "adminnie" on study "STU00144"
    And "usergey" is on study "STU00031415"
    When I visit the roles page for "usergey"
    Then I should see "STU00031415"
    When I visit the roles page for "nan"
    Then I should see "No roles found"
