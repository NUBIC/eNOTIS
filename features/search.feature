Feature: Search
  In order to find subjects or studies
  As a user
  I want to search by various terms
  
  Background:
    Given a study "Vitamin E and exertion" with id "STU001251" and irb_status "Approved"
    And a study "Vitamin F and fatigue" with id "STU001252" and irb_status "Approved"
    And a study "Vitamin G and gingivitis" with id "STU001253" and irb_status "Review"
    And the study "STU001251" has the following subjects
      | first_name | last_name |
      | Marge      | Innovera  |
      | Picop N    | Droppov   |
      | Rex        | Karrs     |
    And the study "STU001252" has the following subjects
      | first_name | last_name |
      | Buck       | Stoppsier |
    And I log in as "joe" with password "secret" on study "STU001251"
    And I go to the homepage

  Scenario: A user can search for studies (by id)
    When I search for "STU00125" 
    Then I should see title "Approved: Vitamin E and exertion"
    And I should see "3 studies found"

  Scenario: A user can search for studies (with keyword in title/short title)
    When I search for "Vitamin E"
    Then I should see title "Approved: Vitamin E and exertion"
    And I should see "1 study found"
    
  Scenario: A user can search for studies (fail)
    When I search for "90210"
    Then I should see "0 studies found"
    And I should be on the search page

  Scenario: A user can search for subjects
    When I search for "Marge"
    Then I should see "1 subject found"
  
  Scenario: A user can search for subjects and studies
    When I search for "ex"
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
  
