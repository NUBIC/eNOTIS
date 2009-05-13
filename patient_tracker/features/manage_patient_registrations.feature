Feature: Manage patient_registrations
  In order to register patients on a protocol
  As a coordniator
  I want to find an protocol and add a patient
  
  Scenario: Finding the right protocol
    Given I am on the 'protocol' page 
    And I know the study_id
    And I press "Find study"
    Then I should see the protocol with the study_id I entered

  Scenario: Adding the patient that exists
    Given I am looking at the right protocol
    And I enter the patient_mrn
    And I press "Add patient"
    Then I should see a patient details screen
    And I press "Confirm"
    Then I should see the patient in the patient protocol list

  Scenario: Adding the patient that does not exist
    Give I am looking at the right protocol
    And I have the patient_mrn
    And I press "Add patient"
    Then I see a message indicating the patient was not found
    And I enter the details manually
    And I press "Submit"
    Then I should see the patient in the patient protocol list with a note attached
