Feature: Query EDW for subject info
  In order to find information about a subject
  The application should query the EDW

  Scenario: Search by mrn
    Given there is a subject with MRN 9021090210 named Bev Hills
    When I find a subject by MRN 9021090210
    Then I should get a subject named Bev Hills
  
  Scenario: Search by name and birthday
    Given there is a subject named Pi Patel with birthday 3/1/41 with address 314 Circle Dr.
    When I find a subject by name Pi Patel
    Then I should get a list of subjects with name Pi Patel