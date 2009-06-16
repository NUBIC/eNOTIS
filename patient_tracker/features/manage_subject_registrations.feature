Feature: Manage subject_registrations
  In order to register subjects on a protocol
  As a coordniator
  I want to find an protocol and add a subject
  
  Scenario: Finding the right protocol
    Given I am on the 'protocol' page 
    And I know the study_id
    And I press "Find study"
    Then I should see the protocol with the study_id I entered

  Scenario: Adding the subject that exists
    Given I am looking at the right protocol
    And I enter the subject_mrn
    And I press "Add subject"
    Then I should see a subject details screen
    And I press "Confirm"
    Then I should see the subject in the subject protocol list

  Scenario: Adding the subject that does not exist
    Give I am looking at the right protocol
    And I have the subject_mrn
    And I press "Add subject"
    Then I see a message indicating the subject was not found
    And I enter the details manually
    And I press "Submit"
    Then I should see the subject in the subject protocol list with a note attached
