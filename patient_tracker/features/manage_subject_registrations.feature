Feature: Manage subject_registrations
  In order to register subjects on a study
  As a coordniator
  I want to find an study and add a subject
  
  Scenario: Finding the right study
    Given I am on the 'study' page 
    And I know the study_id
    And I press "Find study"
    Then I should see the study with the study_id I entered

  Scenario: Adding the subject that exists
    Given I am looking at the right study
    And I enter the subject_mrn
    And I press "Add subject"
    Then I should see a subject details screen
    And I press "Confirm"
    Then I should see the subject in the subject study list

  Scenario: Adding the subject that does not exist
    Give I am looking at the right study
    And I have the subject_mrn
    And I press "Add subject"
    Then I see a message indicating the subject was not found
    And I enter the details manually
    And I press "Submit"
    Then I should see the subject in the subject study list with a note attached
