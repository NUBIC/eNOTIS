Feature: Manage subjects
  In order to register subjects on a study
  As a coordinator
  I want to find add subjects to a study
  
  Background:
    Given I log in as "pi"
    Given a study "Vitamin E and exertion" with id "1248F" and status "Approved"
    Given "pi" has access to study id "1248F"
  
  @focus
  Scenario: A coordinator can add a subject that exists
    Given a subject with mrn "90210"
    When I go to the study page for id "1248F"
    Then I should see "Add Subject"
    And I follow "Add Subject"
    And I enter mrn "90210"
    And I press "submit"
    Then I should see "success"

  Scenario: A coordinator can add a subject that does not exist
    # When I go to the study page for id "1248F"
    # And I have the subject_mrn
    # And I press "Add subject"
    # Then I should see a message indicating the subject was not found

  Scenario: A coordinator can add a subject that does not exist
    # When I go to the study page for id "1248F"
    # And I have the subject_mrn
    # And I press "Add subject"
    # And I see a message indicating the subject was not found
    # And I enter the details manually
    # And I press "Submit"
    # Then I should see the subject in the subject study list with a note attached

  Scenario: A coordinator can add a subject that can be located in the medical record
    Given
    When
    Then

  Scenario: A coordinator can add a subject that can not be located in the medical record
    Given
    When
    Then

  Scenario: A coordinator can view the synced/not synced with medical record status
    Given
    When
    Then

  Scenario: A coordinator can add an event for a new subject
    Given
    When
    Then

  Scenario: A coordinator can add an event for an existing subject
    Given
    When
    Then

  Scenario: A coordinator can remove an event for an existing subject
    Given
    When
    Then

  Scenario: A coordinator can remove a subject by deleting all involvement events
    Given
    When
    Then

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