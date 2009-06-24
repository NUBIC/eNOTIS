@focus
Feature: User access to system
  In order to access eNotis
  As a user
  I want to be able to login or get a helpful message
  
  Scenario: An authorized user should be able to login
    Given a user "pi" with password "314159"
    When I log in as "pi" with password "314159"
    Then I should see "Dashboard"

  Scenario: A user with typos should get a helpful message
    Given a user "pi" with password "314159"
    When I log in as "pi" with password "theinternets"
    Then I should see "Couldn't log you in as 'pi'"
    And I should see "http://www.it.northwestern.edu/netid/password.html"
  
  Scenario: An unauthorized user should get a helpful message
    Given a user "pi" with password "314159"
    And is not authorized on any studies
    When I log in as "pi" with password "314159"
    Then I should see "on any studies"
    And I should see "eIRB"

  Scenario: A logged in user can logout
    Given a user "pi" with password "314159"
    When I log in as "pi" with password "314159"
    And I follow "pi"
    Then I should see "logged out"
    And I should be on the login page