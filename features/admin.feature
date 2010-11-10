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
    And I should see "active (non NOTIS) studies"
  
  Scenario: An admin user should be able to see study uploads
    Given I log in as admin "admin" with password "secret"
    And a study "Vitamin C and concentration" with id "STU001248" and irb_status "Approved"
    When I go to the study page for id "STU001248"
    And I upload the "good.csv" file
    And I go to the hub page
    Then I should be on the hub page
    And I should see "1 recent upload"
    And I should see "Consented: 7, Completed: 3, Withdrawn: 2"
  
  Scenario: An admin user should be able to see active users and studies
    Given I log in as admin "admin" with password "secret"
    And a user "bob" named "Bob" "Loblaw"
    And "bob" is on study "STU00031415"
    When I visit the roles page for "bob"
    Then I should see "STU00031415"
    When I visit the roles page for "nan"
    Then I should see "not found"