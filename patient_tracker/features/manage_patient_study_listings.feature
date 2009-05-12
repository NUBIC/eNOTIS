Feature: Manage patient_study_listings
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  Scenario: Register new patient_study_listing
    Given I am on the new patient_study_listing page
    And I press "Create"

  Scenario: Delete patient_study_listing
    Given the following patient_study_listings:
      ||
      ||
      ||
      ||
      ||
    When I delete the 3rd patient_study_listing
    Then I should see the following patient_study_listings:
      ||
      ||
      ||
      ||
