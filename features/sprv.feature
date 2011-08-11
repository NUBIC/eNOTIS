Feature: Study patient research voucher
  In order to satisfy our clinical partners
  As a coordinator
  I want to download the SPRV and get instructions on encryption
  
  Background:
    Given a study "Vitamin D and delerium" with id "STU001248" and irb_status "Approved"
    And I log in as "usergey" on study "STU001248"

  Scenario: A coordinator can see the SPRV and instructions
    When I follow "Help"
    Then I should be on the help page
    And I should see "Encryption details"