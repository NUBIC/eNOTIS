Feature: Manage subjects
  In order to register subjects on a study
  As a coordinator
  I want to find add subjects to a study
  
  Scenario: A coordinator can add a subject that exists
    Given I am looking at the right study
    And I enter the subject_mrn
    And I press "Add subject"
    Then I should see a subject details screen
    And I press "Confirm"
    Then I should see the subject in the subject study list

  Scenario: A coordinator can add a subject that does not exist
    Give I am looking at the right study
    And I have the subject_mrn
    And I press "Add subject"
    Then I see a message indicating the subject was not found
    And I enter the details manually
    And I press "Submit"
    Then I should see the subject in the subject study list with a note attached

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