Feature: Manage subjects
  In order to update a study
  As a coordinator
  I want to add subjects to a study
  
  Background:
    Given I log in as "pi"
    And a study "Vitamin D and delerium" with id "STU001248" and status "Approved"
    And "pi" has access to study id "STU001248"

  Scenario: A coordinator can see the add subject form
    When I go to the study page for id "STU001248"
    And I follow "Add Subject"
    Then I should see the add subject form

  # Scenario: A coordinator can add an event for a new subject
  # Scenario: A coordinator can add a subject that can be located in the medical record
  Scenario: A coordinator can add a subject that exists
    Given a subject with mrn "90210a"
    When I go to the study page for id "STU001248"
    And I follow "Add Subject"
    And I fill in "MRN" with "90210a"
    And I select "Male" from "Gender"
    And I select "Not Hispanic Or Latino" from "Ethnicity"
    And I check "Asian"
    And I select "Consented" from "Activity"
    And I fill in "Event Date" with "2009-07-01"
    And I press "Submit"
    Then I should be on the study page for id "STU001248"
    And I should see "Created"
  
  ## TODO - yoon - if we're unable to connect to irb/edw, we shouldn't have to wait for a long time for the connection to time out
  Scenario: A coordinator cannot add a subject (by MRN) that does not exist
    When I go to the study page for id "STU001248"
    And I follow "Add Subject"
    And I fill in "MRN" with "123XYZ"
    And I select "Male" from "Gender"
    And I select "Not Hispanic Or Latino" from "Ethnicity"
    And I check "Asian"
    And I select "Consented" from "Activity"
    And I fill in "Event Date" with "2009-07-01"
    And I press "Submit"
    Then I should be on the study page for id "STU001248"
    And I should see "Error"
  
  # Scenario: A coordinator can add a subject that can not be located in the medical record
  Scenario: A coordinator can add a subject (by fn/ln/dob) that does not exist
    When I go to the study page for id "STU001248"
    And I follow "Add Subject"
    And I fill in "First Name" with "Jack"
    And I fill in "Last Name" with "Daripur"
    And I fill in "Birth Date" with "8/7/65"
    And I select "Male" from "Gender"
    And I select "Not Hispanic Or Latino" from "Ethnicity"
    And I check "Asian"
    And I select "Consented" from "Activity"
    And I fill in "Event Date" with "2009-07-01"
    And I press "Submit"
    Then I should be on the study page for id "STU001248"
    And I should see "Created"

  Scenario: A coordinator can add a subject with only a casenumber
    When I go to the study page for id "STU001248"
    And I follow "Add Subject"
    And I fill in "Case Number" with "Case2"
    And I select "Male" from "Gender"
    And I select "Not Hispanic Or Latino" from "Ethnicity"
    And I check "Asian"
    And I select "Consented" from "Activity"
    And I fill in "Event Date" with "2009-07-01"
    And I press "Submit"
    Then I should be on the study page for id "STU001248"
    And I should see "Created"

  Scenario: A coordinator can view the synced/not synced with medical record status
    Given the study "STU001248" has the following subjects
      | first_name | last_name | mrn   |
      | Holly      | Wood      | 90210b | 
    And subject "90210b" is not synced
    And subject "90210b" has event "Consented" on study "STU001248"
    When I go to the study page for id "STU001248"
    Then I should see an image with alt "sync"
  
  Scenario: A coordinator can see the add event form
    Given the study "STU001248" has the following subjects
      | first_name | last_name | mrn   |
      | Holly      | Wood      | 90210c | 
    And subject "90210c" has event "Consented" on study "STU001248"
    When I go to the study page for id "STU001248"
    Then I should see the add event form

  Scenario: A coordinator can add an event for an existing subject
    Given the study "STU001248" has the following subjects
      | first_name | last_name | mrn   |
      | Holly      | Wood      | 90210d |
    And subject "90210d" has event "Consented" on study "STU001248"
    When I go to the study page for id "STU001248"
    And I follow "Holly Wood"
    And I follow "Add Event"
    And I select "Contact - phone" from "Event Type"
    And I fill in "Event Date" with "2009-07-01"
    And I press "Submit"
    Then I should be on the study page for id "STU001248"
    And I should see "Added"
    And I should see "Contact - phone"
    And subject "90210d" should have 2 events on study "STU001248"

  Scenario: A coordinator can remove an event for an existing subject
    Given a subject with mrn "90210e"
    And subject "90210e" has event "Consented" on study "STU001248"
    And subject "90210e" has event "Randomization" on study "STU001248"
    When I go to the study page for id "STU001248"
    Then I should see "Consented"
    And I should see "Randomization"
    When I follow "Consented"
    And I follow "Remove this event"
    Then subject "90210e" should have 1 event on study "STU001248"
  
  Scenario: A coordinator can remove a subject by deleting all involvement events
    Given a subject with mrn "90210f"
    And subject "90210f" has event "Consented" on study "STU001248"
    When I go to the study page for id "STU001248"
    And I follow "Consented"
    And I follow "Remove this event"
    Then subject "90210f" should not be involved with study "STU001248"
  
  Scenario: A coordinator can view the event history on a subject, but only that for events on studies they have access to
    Given the study "STU001248" has the following subjects
      | first_name | last_name | mrn   |
      | Bo         | Tannik    | 90210g |
    And a study "Vitamin M and materialism" with id "1248M" and status "Approved"
    And subject "90210g" has event "Consented" on study "STU001248"
    And subject "90210g" has event "Randomization" on study "STU001248"
    And subject "90210g" has event "Consented" on study "1248M"
    When I go to the study page for id "STU001248"
    And I follow "Bo Tannik"
    Then I should see events for "Vitamin E and exertion"
    And I should not see "Vitamin M and materialism"

  # Won't do per chat with David/Brian on 8/4 (is kinda irrelevant - there's not data that we show anymore)- yoon
  # Scenario: A coordinator can view data on a user they entered (user data) that has been synced with medical record (EDW)

