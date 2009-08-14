Feature: Developer admin access
  In order to help users
  As a developer
  I want to be able see users, netids, and studies, as well as dictionary term

  Scenario: A normal user should not be able to visit the hub
    Given a user "gns144" with password "stjames"
    And "gns144" has access to study id "144"
    When I log in as "gns144" with password "stjames"
    And I go to the hub page
    Then I should be on the dashboard
    
  Scenario: An admin should be able to visit the hub
    Given an admin "pbr312"
    When I log in as "pbr312" with password "beer"
    And I go to the hub page
    Then I should see "user"
    And I should see "dictionary terms"
    
  Scenario: An admin should be able to see users and netids
    Given an admin "pbr312"
    And the following users
      | first_name | last_name | netid  |
      | Pi         | Patel     | pip312 |
      | Noah       | Fence     | nof112 |
      | Joe        | King      | jki123 |
    When I log in as "pbr312" with password "beer"
    And I go to the hub page
    Then I should see "4 users" 
    And I should see "Pi Patel"
    And I should see "pip312"
    And I should see "Noah Fence"
    And I should see "Joe King"
  
  Scenario: An admin should be able to see users and netids
    Given an admin "pbr312"
    And the following dictionary terms
      | category | term | code |  
      | Foo      | Bar  | fr   |
      | Foo      | Baz  | fz   |
      | Foo      | Bak  | fk   |
    When I log in as "pbr312" with password "beer"
    And I go to the hub page
    Then I should see "Foo"
    And I should see "Bar"
    And I should see "Baz"
    And I should see "Bak"
    