Feature: Manage patient_registrations
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  Scenario: Register new patient_registration
    Given I am on the new patient_registration page
    And I press "Create"

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
