Feature: User access to system
  In order to access eNotis
  As a user
  I want to be able to login or get a helpful message

  Scenario: An authorized user should be able to login
    When I log in as "usergey" on study "STU0001234"
    Then I should see "(usergey)"
    And I should see "Logout"

  # Scenario: A user with typos should get a password message
  #   When I log in as "usergey" with password "theinternets"
  #   Then I should see "Couldn't log you in as 'usergey'"
  #   And I should see "password.northwestern.edu"
  
  # Scenario: An authenticated user not in users table should get a "not associated" message
  #   Given a nonuser "notinusers" with password "314159"
  #   When I log in as "notinusers" with password "314159"
  #   Then I should see "not currently associated"
    
  # Scenario: An authenticated user in users table without studies should get a "not associated" message
  #   Given a user "pi" with password "314159"
  #   And "pi" is not authorized on any studies
  #   When I log in as "pi" with password "314159"
  #   Then I should see "not currently associated"
  
  @focus
  Scenario: A logged in user can access help and faq
    Given I log in as "usergey" on study "STU0001234"
    When I follow "Help"
    Then I should see "Need support?"
    And I should see "FAQ"

  Scenario: A logged in user can logout
    Given I log in as "usergey" on study "STU0001234"
    When I follow "Logout"
    Then I should see "Logged out"
    # And I should be on the login page
