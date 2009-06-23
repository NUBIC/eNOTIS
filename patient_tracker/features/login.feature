Feature: User access to system
  In order to access eNotis
  As a user
  I want to be able to login or get a helpful message
  
  @focus
  Scenario: An authorized user should be able to login
    Given a user "pi" with password "314159"
    When I log in as "pi" with password "314159"
    Then I should see "Dashboard"

  Scenario: A user with typos should get a helpful message
    Given a user "pi" with password "314159"
    When I log in as "pi" with password "theinternets"
    And I should see "netid or password"
    And I should see "http://www.it.northwestern.edu/netid/password.html"
    
  Scenario: An unauthorized user should get a helpful message
    Given a user with a valid netid and password
    And is not authorized on any studies
    When I visit the application and click "login"
    Then I should see a helpful error message

  Scenario: A logged in user can logout
