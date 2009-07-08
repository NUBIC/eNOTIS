Feature: Search
  In order to find subjects or studies or events
  As a user
  I want to search by various terms
  
  Background:
    Given I log in as "pi"
    Given a study "Vitamin E and exertion" with id "1248F" and status "Approved"
    And "pi" has access to study id "1248F"
    And the study "1248F" has the following subjects
      | first_name | last_name |
      | Marge      | Innovera  |
      | Picop N    | Dropov    |
  
  @focus
  Scenario: A user clicks the "Search" button
    When I follow "Search"
    Then I should see "studies or subjects"
    And I should not see "Notice: No studies found"
    And I should not see "Find study"
