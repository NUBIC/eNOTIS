Feature: Manage subjects
  In order to update a study
  As a coordinator
  I want to add subjects to a study
  
  Background:
    Given a study "Vitamin D and delerium" with id "STU001248" and irb_status "Approved"
    And I log in as "pi" with password "secret" on study "STU001248"
    And I go to the study page for id "STU001248"
  
  Scenario: A coordinator can add a subject
    When I add a subject "Jack" "Daripur" with "Consented" on "2009-07-01"
    Then I should be on the study page for id "STU001248"
    And I should see "Created"

  Scenario: A coordinator can add a subject with only a casenumber
    When I add a case number "0021" with "Consented" on "2009-08-02"
    Then I should be on the study page for id "STU001248"
    And I should see "Created"

  Scenario: A coordinator can add an event for an existing subject
    # And subject "90210d" should have 2 events on study "STU001248"

  Scenario: A coordinator can remove an event for an existing subject
    # Then subject "90210e" should have 1 event on study "STU001248"
  
  Scenario: A coordinator can remove a subject by deleting all involvement events
    # Then subject "90210f" should not be involved with study "STU001248"
