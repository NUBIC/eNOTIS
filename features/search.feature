Feature: Search
  In order to find subjects or studies
  As a user
  I want to search by various terms
  
  Background:
    Given a user "joe" with password "1234"
    And a study "Vitamin E and exertion" with id "1248E" and status "Approved"
    And a study "Vitamin F and fatigue" with id "1248F" and status "Approved"
    And a study "Vitamin G and gingivitis" with id "1248G" and status "Review"
    And "joe" has access to study id "1248E"
    And the study "1248E" has the following subjects
      | first_name | last_name |
      | Marge      | Innovera  |
      | Picop N    | Droppov   |
      | Rex        | Karrs     |
    And the study "1248F" has the following subjects
      | first_name | last_name |
      | Buck       | Stoppsier |
    And I log in as "joe" with password "1234"

  Scenario: Verifying my studies
    When I go to the homepage
    Then I should see "My Studies (1"
      
  Scenario: Verifying all studies
    When I go to the all studies page
    Then I should see "All Studies (3)"

  Scenario: A user searches for some subjects, studies
    When I go to the search page
    And I search for "Marge"
    Then I should see "1 subject found"
  
  Scenario: A user searches for some subjects, studies
    When I go to the search page
    And I search for "ex"
    Then I should see "1 subject found"
    And I should see "1 study found"
  
  Scenario: A user searches for some subjects, studies, study statuses
    When I go to the search page
    And I search for "pp"
    Then I should see "1 subject found"
    And I should see "Picop N Droppov"
    And I should see "2 studies found"
    And I should see "Vitamin E"
    And I should see "Vitamin F"
  
  Scenario: A user searches for studies lowercase
  # Searchlogic does ILIKE for Postgres, but not for other db engines
    # When I go to the search page
    # And I search for "vitamin"
    # Then I should see "0 subjects found"
    # And I should see "2 studies found"
    # And I should see "Vitamin E"
    # And I should see "Vitamin F"
  