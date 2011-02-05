Feature: Proxy User Report Services
  In order to update medical services forms
  As an Overseer
  I want to edit the services on a study

  Background:
    Given a study "Vitamin C and concentration" with id "STU0004321" and irb_status "Approved"
    Given I log in as "bigbro"

  Scenario: An Overseer can see the services page
    pending
    #When I go to the services page
    #Then I should see "STU0004321"

  Scenario: An Overseer can see a study services page
    pending
    #When I go to the services page for "STU0004321"
    #Then I should see "STU0004321"

  Scenario: An Overseer cannot see a study subjects page
    pending
    #When I go to the study page for id "STU0004321"
    #Then I should be redirected to the services page
    #And I should see "Access Denied"

