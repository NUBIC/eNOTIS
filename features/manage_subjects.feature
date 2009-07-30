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
    And subject "90210" is consented on study "1248F"
    When I go to the study page for id "1248F"
    Then I should see that subject "90210" is not synced
    
  @focus
  Scenario: A coordinator can see the add evebt form
    Given a subject with mrn "90210"
    And subject "90210" is consented on study "1248F"
    When I go to the study page for id "1248F"
    And I follow "Add Event" for "90210"
    Then I should see the add event form

  @focus
  Scenario: A coordinator can add an event for an existing subject
    Given a subject with mrn "90210"
    And subject "90210" is consented on study "1248F"
    When I go to the study page for id "1248F"
    And I follow "Add Event" for "90210"
    And I select "Contact - Phone" from "Event Type"
    And I fill in "Event Date" with "2009-07-01"
    And I press "Submit"
    Then I should be on the study page for id "1248F"
    And I should see "Added"

  Scenario: A coordinator can remove an event for an existing subject
    Given
    When
    Then

  Scenario: A coordinator can remove a subject by deleting all involvement events
    Pending

  Scenario: A coordinator can view the event history on a subject
    Given
    When
    Then

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