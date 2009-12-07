Feature: User access to system
  In order to access eNotis
  As a user
  I want to be able to login or get a helpful message

  Background: 
    Given a user "pi" with password "314159"
    And "pi" has access to study id "1234"

  Scenario: An authorized user should be able to login
    When I log in as "pi" with password "314159"
    Then I should see "(pi)"
    And I should see "Logout"

  Scenario: A user with typos should get a helpful message
    When I log in as "pi" with password "theinternets"
    Then I should see "Couldn't log you in as 'pi'"
    And I should see "password.northwestern.edu"
  
  Scenario: An unauthorized user should get a helpful message
    Given "pi" is not authorized on any studies
    When I log in as "pi" with password "314159"
    Then I should see "on any studies"
    And I should see "eIRB"

  Scenario: A logged in user can logout
    When I log in as "pi" with password "314159"
    And I follow "Logout"
    Then I should see "logged out"
    And I should be on the login page