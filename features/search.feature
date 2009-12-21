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
    And I go to the homepage

  Scenario: A user can search for studies (by id)
    And I search for "1248"
    Then I should see title "Approved: Vitamin E and exertion"
    And I should see "3 studies found"

  Scenario: A user can search for studies (with keyword in title/short title)
    And I search for "Vitamin E"
    Then I should see title "Approved: Vitamin E and exertion"
    And I should see "1 study found"
    
  Scenario: A user can search for studies (fail)
    And I search for "90210"
    Then I should see "0 studies found"
    And I should be on the search page

  Scenario: A user can search for subjects
    And I search for "Marge"
    Then I should see "1 subject found"
  
  Scenario: A user can search for subjects and studies
    And I search for "ex"
    Then I should see "1 subject found"
    And I should see "1 study found"
  
  Scenario: A user can search for some subjects, studies, statuses
    When I go to the search page
    And I search for "pp"
    Then I should see "1 subject found"
    And I should see "Droppov"
    And I should not see "Stoppsier"
    And I should see "2 studies found"
    And I should see title "Approved: Vitamin E and exertion"
    And I should see "Vitamin F and fatigue"
  
  Scenario: A user searches for studies lowercase
  # Searchlogic does ILIKE for Postgres, but not for other db engines
    # When I go to the search page
    # And I search for "vitamin"
    # Then I should see "0 subjects found"
    # And I should see "2 studies found"
    # And I should see "Vitamin E"
    # And I should see "Vitamin F"
  