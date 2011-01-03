Feature: Audit trail
  In order to track user activity
  As a developer
  I want to be able see versions and activity

  Background:
    Given I log in as "usergey" on study "STU001248"
    
  Scenario: Logging in
    Then there should be 0 activities with
      | controller   | action | whodiddit |

  Scenario: Adding subjects
    Given a study "Vitamin D and delerium" with id "STU001248" and irb_status "Approved"
    And I log in as "usergey" on study "STU001248"
    And I go to the study page for id "STU001248"
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
    When I search for "STU00125" 
    Then there should be 1 activity with
      | controller | action | whodiddit |
      | search     | show   | usergey   |
      
  Scenario: Uploads
    Given I log in as "usergey" on study "STU001248"
    When I go to the study page for id "STU001248"
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
