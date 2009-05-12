Feature: Manage patient_registrations
  In order to register patients on a protocol
  [stakeholder]
  wants [behaviour]
  
  Scenario: Create new patient_registration
    Given I am on the 'protocol/show' page 
    And I press "Register Patient"
    Then I should see a form to look up a patient

  Scenario: Delete patient_registration
    Given the following patient_registrations:
      ||
      ||
      ||
      ||
      ||

    When I delete the 3rd patient_registration
    Then I should see the following patient_registrations:
      ||
      ||
      ||
      ||
