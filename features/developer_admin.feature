Feature: Developer admin access
  In order to help users
  As a developer
  I want to be able see users, netids, and studies, as well as dictionary term

  Background: 
    Given an admin "pbr312"

  Scenario: An admin should be able to visit the hub
    When I log in as "pbr312" with password "beer"
    And I go to the hub page
    Then I should see "Users"
    And I should see "Dictionary Terms"