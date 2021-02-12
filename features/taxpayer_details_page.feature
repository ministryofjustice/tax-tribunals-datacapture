Feature: Taxpayer details page

Background: Taxpayer details page
  Given I navigate to the taxpayer details page

  Scenario: Successfully submit taxpayer details
    When I successfully submit taxpayers details
    Then I am taken to representative page

  Scenario: Unsuccessfully submit taxpayer details
    When I submit a blank taxpayers details form
    Then I am shown all the taxpayer details errors
    And I am on the taxpayer details page