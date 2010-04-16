Feature: Developer admin access
  In order to help users
  As a developer
  I want to be able see users, netids, and studies, as well as dictionary term

  Scenario: A normal user should not be able to visit the hub
    Given I log in as "gns144" with password "stjames" on study "STU00144"
    And I go to the hub page
    Then I should be on the homepage
