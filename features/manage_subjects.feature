Feature: Manage subjects
  In order to register subjects on a study
  As a coordinator
  I want to find add subjects to a study
  
  Background:
    Given I log in as "pi"
    Given a study "Vitamin E and exertion" with id "1248F" and status "Approved"
    Given "pi" has access to study id "1248F"

  Scenario: A coordinator can see the add subject form
    When I go to the study page for id "1248F"
    And I follow "Add Subject"
    Then I should see the add subject form

  # Scenario: A coordinator can add an event for a new subject
  # Scenario: A coordinator can add a subject that can be located in the medical record
  Scenario: A coordinator can add a subject that exists
    Given a subject with mrn "90210"
    When I go to the study page for id "1248F"
    And I follow "Add Subject"
    And I fill in "MRN" with "90210"
    And I select "Male" from "Gender"
    And I select "Not Hispanic or Latino" from "Ethnicity"
    And I check "Asian"
    And I select "Consented" from "Event Type"
    And I fill in "Event Date" with "2009-07-01"
    And I press "Submit"
    Then I should be on the study page for id "1248F"
    And I should see "Created"
  
  ## TODO - yoon - if we're unable to connect to irb/edw, we shouldn't have to wait for a long time for the connection to time out
  
  Scenario: A coordinator cannot add a subject (by MRN) that does not exist
    Given a subject with mrn "90210"
    When I go to the study page for id "1248F"
    And I follow "Add Subject"
    And I fill in "MRN" with "123XYZ"
    And I select "Male" from "Gender"
    And I select "Not Hispanic or Latino" from "Ethnicity"
    And I check "Asian"
    And I select "Consented" from "Event Type"
    And I fill in "Event Date" with "2009-07-01"
    And I press "Submit"
    Then I should be on the study page for id "1248F"
    And I should see "Error"
  
  # Scenario: A coordinator can add a subject that can not be located in the medical record
  Scenario: A coordinator can add a subject (by fn/ln/dob) that does not exist
    When I go to the study page for id "1248F"
    And I follow "Add Subject"
    And I fill in "First Name" with "Jack"
    And I fill in "Last Name" with "Daripur"
    And I fill in "Birth Date" with "8/7/65"
    And I select "Male" from "Gender"
    And I select "Not Hispanic or Latino" from "Ethnicity"
    And I check "Asian"
    And I select "Consented" from "Event Type"
    And I fill in "Event Date" with "2009-07-01"
    And I press "Submit"
    Then I should be on the study page for id "1248F"
    And I should see "Created"

  Scenario: A coordinator can view the synced/not synced with medical record status
    Given a subject with mrn "90210"
    And subject "90210" is not synced
    And subject "90210" has event "Consented" on study "1248F"
    When I go to the study page for id "1248F"
    Then I should see that subject "90210" is not synced
  
  Scenario: A coordinator can see the add event form
    Given a subject with mrn "90210"
    And subject "90210" has event "Consented" on study "1248F"
    When I go to the study page for id "1248F"
    And I follow "Add Event" for "90210" on the "Subjects" tab
    Then I should see the add event form

  Scenario: A coordinator can add an event for an existing subject
    Given a subject with mrn "90210"
    And subject "90210" has event "Consented" on study "1248F"
    When I go to the study page for id "1248F"
    And I follow "Add Event" for "90210" on the "Subjects" tab
    And I select "Contact - Phone" from "Event Type"
    And I fill in "Event Date" with "2009-07-01"
    And I press "Submit"
    Then I should be on the study page for id "1248F"
    And I should see "Added"
    And I should see "Contact - Phone"
    And subject "90210" should have 2 events on study "1248F"
  
  Scenario: A coordinator can remove an event for an existing subject
    Given a subject with mrn "90210"
    And subject "90210" has event "Consented" on study "1248F"
    And subject "90210" has event "Randomization" on study "1248F"
    When I go to the study page for id "1248F"
    Then I should see "Consented"
    And I should see "Randomization"
    When I follow "Consented" for "90210" on the "Events" tab
    And I follow "Remove this event"
    Then subject "90210" should have 1 event on study "1248F"
  
  Scenario: A coordinator can remove a subject by deleting all involvement events
    Given a subject with mrn "90210"
    And subject "90210" has event "Consented" on study "1248F"
    When I go to the study page for id "1248F"
    And I follow "Consented" for "90210" on the "Events" tab
    And I follow "Remove this event"
    Then subject "90210" should not be involved with study "1248F"

  Scenario: A coordinator can view the event history on a subject, only on studies they have access to
    # Given a study "Vitamin F and fatigue" with id "F8910" and status "Approved"
    # And a study "Vitamin M and materialism" with id "58008" and status "Approved"
    # And "pi" has access to study id "1248F"
    # And a subject with mrn "90210" named "Bo" "Tannik"
    # And subject "90210" has event "Consented" on study "1248F"
    # And subject "90210" has event "Randomization" on study "F8910"
    # And subject "90210" has event "Consented" on study "58008"
    # When I go to the study page for id "1248F"
    # And I follow "Bo Tannik"
    # Then I should see 2 events

  Scenario: A coordinator can view data on a user they entered (user data) that has been synced with medical record (EDW)
    Given
    When
    Then

  Scenario: A coordinator can upload a subject list from a file to the study
    Given
    When
    Then

  Scenario: A coordinator can search for a subject on their studies (with mrn, name)
    Given
    When
    Then

  Scenario: A coordinator can search but cannot find a subject *not* on their studies 
    Given
    When
    Then