Feature: Taxpayer details page

Background: Taxpayer details page
  Given I navigate to the closure taxpayer details page as a taxpayer

  Scenario: Successfully submit taxpayer details
    When I successfully submit taxpayers details
    Then I am taken to the send taxpayer copy page

  Scenario: Unsuccessfully submit taxpayer details
    When I submit a blank taxpayers details form
    Then I am shown all the taxpayer details errors
    And I am on the taxpayer details page