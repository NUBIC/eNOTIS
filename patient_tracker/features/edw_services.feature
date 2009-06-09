Feature: Query EDW for patient info
  In order to find information about a patient
  The application should query the EDW

  Scenario: Search by mrn
    Given there is a patient with MRN 9021090210 named Bev Hills
    When I find a patient by MRN 9021090210
    Then I should get a patient named Bev Hills
  
  Scenario: Search by name and birthday
    Given there is a patient named Pi Patel with birthday 3/1/41 with address 314 Circle Dr.
    When I find a patient by name Pi Patel and birthday 03/01/1941
    Then I should get a patient with address 31 Circle Dr.