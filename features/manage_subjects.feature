Feature: Manage subjects
  In order to register subjects on a study
  As a coordinator
  I want to find add subjects to a study
  
  Background:
    Given I log in as "pi"
    And a study "Vitamin E and exertion" with id "1248E" and status "Approved"
    And "pi" has access to study id "1248E"

  Scenario: A coordinator can see the add subject form
    When I go to the study page for id "1248E"
    And I follow "Add Subject"
    Then I should see the add subject form

  # Scenario: A coordinator can add an event for a new subject
  # Scenario: A coordinator can add a subject that can be located in the medical record
  Scenario: A coordinator can add a subject that exists
    Given a subject with mrn "90210"
    When I go to the study page for id "1248E"
    And I follow "Add Subject"
    And I fill in "MRN" with "90210"
    And I select "Male" from "Gender"
    And I select "Not Hispanic or Latino" from "Ethnicity"
    And I check "Asian"
    And I select "Consented" from "Event Type"
    And I fill in "Event Date" with "2009-07-01"
    And I press "Submit"
    Then I should be on the study page for id "1248E"
    And I should see "Created"
  
  ## TODO - yoon - if we're unable to connect to irb/edw, we shouldn't have to wait for a long time for the connection to time out
  
  Scenario: A coordinator cannot add a subject (by MRN) that does not exist
    Given a subject with mrn "90210"
    When I go to the study page for id "1248E"
    And I follow "Add Subject"
    And I fill in "MRN" with "123XYZ"
    And I select "Male" from "Gender"
    And I select "Not Hispanic or Latino" from "Ethnicity"
    And I check "Asian"
    And I select "Consented" from "Event Type"
    And I fill in "Event Date" with "2009-07-01"
    And I press "Submit"
    Then I should be on the study page for id "1248E"
    And I should see "Error"
  
  # Scenario: A coordinator can add a subject that can not be located in the medical record
  Scenario: A coordinator can add a subject (by fn/ln/dob) that does not exist
    When I go to the study page for id "1248E"
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
    Then I should be on the study page for id "1248E"
    And I should see "Created"

  Scenario: A coordinator can view the synced/not synced with medical record status
    Given a subject with mrn "90210"
    And subject "90210" is not synced
    And subject "90210" has event "Consented" on study "1248E"
    When I go to the study page for id "1248E"
    Then I should see that subject "90210" is not synced
  
  Scenario: A coordinator can see the add event form
    Given a subject with mrn "90210"
    And subject "90210" has event "Consented" on study "1248E"
    When I go to the study page for id "1248E"
    And I follow "Add Event" for "90210" on the "Subjects" tab
    Then I should see the add event form

  Scenario: A coordinator can add an event for an existing subject
    Given a subject with mrn "90210"
    And subject "90210" has event "Consented" on study "1248E"
    When I go to the study page for id "1248E"
    And I follow "Add Event" for "90210" on the "Subjects" tab
    And I select "Contact - Phone" from "Event Type"
    And I fill in "Event Date" with "2009-07-01"
    And I press "Submit"
    Then I should be on the study page for id "1248E"
    And I should see "Added"
    And I should see "Contact - Phone"
    And subject "90210" should have 2 events on study "1248E"
  
  Scenario: A coordinator can remove an event for an existing subject
    Given a subject with mrn "90210"
    And subject "90210" has event "Consented" on study "1248E"
    And subject "90210" has event "Randomization" on study "1248E"
    When I go to the study page for id "1248E"
    Then I should see "Consented"
    And I should see "Randomization"
    When I follow "Consented" for "90210" on the "Events" tab
    And I follow "Remove this event"
    Then subject "90210" should have 1 event on study "1248E"
  
  Scenario: A coordinator can remove a subject by deleting all involvement events
    Given a subject with mrn "90210"
    And subject "90210" has event "Consented" on study "1248E"
    When I go to the study page for id "1248E"
    And I follow "Consented" for "90210" on the "Events" tab
    And I follow "Remove this event"
    Then subject "90210" should not be involved with study "1248E"
  @focus
  Scenario: A coordinator can view the event history on a subject, but only that for events on studies they have access to
    Given the study "1248E" has the following subjects
      | first_name | last_name | mrn   |
      | Bo         | Tannik    | 90210 |
    And a study "Vitamin M and materialism" with id "1248M" and status "Approved"
    And subject "90210" has event "Consented" on study "1248E"
    And subject "90210" has event "Randomization" on study "1248E"
    And subject "90210" has event "Consented" on study "1248M"
    When I go to the study page for id "1248E"
    And I follow "Bo Tannik"
    Then I should see events for "Vitamin E and exertion"
    And I should not see "Vitamin M and materialism"

  # Won't do per chat with David/Brian on 8/4 (is kinda irrelevant - there's not data that we show anymore)- yoon
  # Scenario: A coordinator can view data on a user they entered (user data) that has been synced with medical record (EDW)

  Scenario: A coordinator can upload a subject list from a file to the study
    When I go to the study page for id "1248E"
    And I upload a file with valid data for 3 subjects
    Then I should see "pi"
    And I should see "Unavailable"
    And I should see "Still Processing"

  Scenario: A coordinator can search for a subject on their studies (with mrn, name)
  # Scenario: A coordinator can search but cannot find a subject *not* on their studies 
    Given a study "Vitamin F and fatigue" with id "1248F" and status "Approved"
    And the study "1248E" has the following subjects
      | first_name | last_name |
      | Marge      | Innovera  |
      | Picop N    | Droppov   |
      | Rex        | Karrs     |
    And the study "1248F" has the following subjects
      | first_name | last_name |
      | Buck       | Stoppsier |
    When I go to the search page
    And I search for "pp"
    Then I should see "1 subject found"
    And I should see "Picop N Droppov"
    And I should not see "Buck Stoppsier"
