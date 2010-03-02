Feature: Developer admin access
  In order to help users
  As a developer
  I want to be able see users, netids, and studies, as well as dictionary term

  Scenario: A normal user should not be able to visit the hub
    Given I log in as "gns144" with password "stjames" on study "STU00144"
    And I go to the hub page
    Then I should be on the homepage
    
  Scenario: An admin should be able to visit the hub, see users and netids, and see dictionary terms
    Given the following users
      | first_name | last_name | netid  |
      | Pi         | Patel     | pip312 |
      | Noah       | Fence     | nof112 |
      | Joe        | King      | jki123 |
    And the following dictionary terms
      | category | term | code |  
      | Foo      | Bar  | fr   |
      | Foo      | Baz  | fz   |
      | Foo      | Bak  | fk   |
    When I log in as admin "pbr312" with password "beer"
    And I go to the hub page
    Then I should be on the hub page
    And I should see "4 users"
    And I should see "Pi Patel"
    And I should see "pip312"
    And I should see "Noah Fence"
    And I should see "Joe King"
    And I should see "dictionary terms"
    And I should see "foo"
    And I should see "bar"
    And I should see "baz"
    And I should see "bak"