Feature: User access to study reports
  In order to access report data
  As a coordinator
  I want to be able to download reports
  
  Background:
    Given a study "Vitamin C and concentration" with id "STU001248" and irb_status "Approved"
    Given I log in as "pi" with password "secret" on study "STU001248"

  Scenario: A coordinator can download all subjects on a study
    Given the study "STU001248" has the following subjects
    | first_name | last_name | nmff_mrn | nmh_mrn | birth_date |
    | Bob        | Cransit  | abh3131  | bbd2121 | 02/19/1930 |
    When I go to the study page for id "STU001248"
    And I export a csv of subjects 
    Then I should see "Bob"
    And I should see "Cransit"
    And I should see "abh3131"
    And I should see "bbd2121"
    And I should see "1930-02-19"