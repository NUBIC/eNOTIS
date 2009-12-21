Feature: Search
  In order to find subjects or studies
  As a user
  I want to search by various terms
  
  Background:
    Given I log in as "joe"
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

  Scenario: Verifying my studies
    When I go to the homepage
    Then I should see "My Studies (1"

  Scenario: A user can search for studies (with study id)
    When I go to the homepage
    And I search for study "1248E"
    Then I should see "Vitamin E and exertion"

  Scenario: A user can search for studies (with keyword in title/short title)
    When I go to the homepage
    And I search for study "Vitamin E"
    Then I should see "Vitamin E and exertion"

  Scenario: A user can search for studies (fail)
    When I go to the homepage
    And I search for study "90210"
    Then I should see "0 studies found"
    And I should be on the search page

  Scenario: A user searches for a subjects
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
    And I should see "Droppov"
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
  