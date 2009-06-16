Feature: Manage subject_study_listings
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  Scenario: Register new subject_study_listing
    Given I am on the new subject_study_listing page
    And I press "Create"

  Scenario: Delete subject_study_listing
    Given the following subject_study_listings:
      ||
      ||
      ||
      ||
      ||
    When I delete the 3rd subject_study_listing
    Then I should see the following subject_study_listings:
      ||
      ||
      ||
      ||
