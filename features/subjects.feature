Feature: Manage subjects
  In order to update a study
  As a coordinator
  I want to add subjects to a study
  
  Background:
    Given a study "Vitamin D and delerium" with id "STU001248" and irb_status "Approved"
    And I log in as "usergey" on study "STU001248"
    And I go to the study page for id "STU001248"

  Scenario: A coordinator can add a subject
    When I add a subject "Jack" "Daripur" with "Consented" on "2009-07-01"
    Then I should be on the study page for id "STU001248"
    And I should see "Created"

  Scenario: A coordinator can add a subject with only a casenumber
    When I add a case number "0021" with "Consented" on "2009-08-02"
    Then I should be on the study page for id "STU001248"
    And I should see "Created"
  
  Scenario: A coordinator can add a subject with full information
    When I add full information on "Jack" "Endabocks" with "Consented" on "2009-11-01"
    Then I should be on the study page for id "STU001248"
    And I should see "Created"

  Scenario: A coordinator can add an event for an existing subject
    When I add a subject "Jack" "Daripur" with "Consented" on "2009-07-01"
    Then I should be on the study page for id "STU001248"
    And I should see "Created"
    And I add edit subject "Jack" "Daripur" with 2nd event "Completed" on "2010-04-19"
    And subject "Jack" "Daripur" should have 2 events on study "STU001248"

  Scenario: A coordinator cannot add a duplicate event for an existing subject
    When I add a subject "Jack" "Daripur" with "Consented" on "2009-07-01"
    Then I should be on the study page for id "STU001248"
    And I should see "Created"
    And I add edit subject "Jack" "Daripur" with 2nd event "Consented" on "2009-07-01"
    Then I should see " has already been entered"
    And subject "Jack" "Daripur" should have 1 events on study "STU001248"

  Scenario: A coordinator can remove a subject with one involvement from a study
    When I add a subject "Jack" "Daripur" with "Consented" on "2009-07-01" and MRN "90210f"
    Then I should be on the study page for id "STU001248"
    And I should see "Created"
    And subject "Jack" "Daripur" should have 1 events on study "STU001248"
    Then I remove subject "Jack" "Daripur"
    And subject "90210f" should not be involved with study "STU001248"

  Scenario: A coordinator can remove a subject with two involvements from a study
    When I add a subject "Jack" "Daripur" with "Consented" on "2009-07-01"
    Then I should be on the study page for id "STU001248"
    And I should see "Created"
    And subject "Jack" "Daripur" should have 1 events on study "STU001248"
    And I add edit subject "Jack" "Daripur" with 2nd event "Completed" on "2010-04-19"
    And subject "Jack" "Daripur" should have 2 events on study "STU001248"
    Then I remove subject "Jack" "Daripur"
    And subject "90210f" should not be involved with study "STU001248"
  
  Scenario: A coordinator can search a subject by NMFF-MRN
    When I look up "nmff_mrn" "nmff-999"
    Then I should see "Frank" "Costello" as a search result
  @focus
  Scenario: A coordinator can see the MRN lookup
    When I follow "Add"
    Then I should see "Look up MRN"
  @focus  
  Scenario: A coordinator should not see the MRN lookup for edits
    When I add a subject "Jack" "Daripur" with "Consented" on "2009-07-01" and MRN "90210f"
    Then I should be on the study page for id "STU001248"
    And I follow "Edit"
    Then I should not see "Look up MRN"