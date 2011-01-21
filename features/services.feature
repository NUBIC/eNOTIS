Feature: Upload subjects
  In order to update NMH services
  As a PI
  I want to add services to a study

  Background:
    And a study "Vitamin C and concentration" with id "STU001248" and irb_status "Approved"
    Given I log in as "usergey" on study "STU001248"

  Scenario: A PI can see studies on the services page
    When I go to the services page
    Then I should see "STU001248"

  Scenario: A PI can see a study services page
    When I go to the services page for "STU0001248"
    Then I should see "STU001248"

  Scenario: The study services page for a bad study will redirect
    When I go to the services page for "BADSTU000"
    Then I should be on the services page
