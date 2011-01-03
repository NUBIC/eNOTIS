Feature: Audit trail
  In order to track user activity
  As a developer
  I want to be able see versions and activity

  Scenario: Logging in
    Given I log in as "usergey" on study "STU001991"
    Then there should be 0 activities with
      | controller   | action | whodiddit |

  Scenario: Adding subjects
    Given a study "Vitamin D and delerium" with id "STU001248" and irb_status "Approved"
    And I log in as "usergey" on study "STU001992"
    And I go to the study page for id "STU001992"
    When I add a subject "Jack" "Daripur" with "Consented" on "2009-07-01"
    Then I should be on the study page for id "STU001248"
    Then there should be 4 activities with
      | controller   | action | whodiddit |
      | studies      | show   | usergey   |
      | involvements | new    | usergey   |
      | involvements | create | usergey   |
    Then there should be 3 versions with
      | item_type        | event  | whodunnit |
      | Subject          | create | usergey   |
      | Involvement      | create | usergey   |
      | InvolvementEvent | create | usergey   |

  Scenario: Search
    Given I log in as "usergey" on study "STU001993"
    When I search for "STU001993" 
    Then there should be 1 activity with
      | controller | action | whodiddit |
      | search     | show   | usergey   |
      
  Scenario: Uploads
    Given I log in as "usergey" on study "STU001994"
    When I go to the study page for id "STU001994"
    And I upload the "good.csv" file
    Then there should be 4 activities with
      | controller   | action | whodiddit |
      | studies      | show   | usergey   |
      | studies      | import | usergey   |
      | involvements | upload | usergey   |
    Then there should be 26 versions with
      | item_type        | event  | whodunnit |
      | Subject          | create | usergey   |
      | Involvement      | create | usergey   |
      | InvolvementEvent | create | usergey   |
