Feature: Taxpayer details page

Background: Taxpayer details page
  Given I am on the taxpayer details page

  Scenario: Successfully submit taxpayer details
    When I successfully submit taxpayers details
    Then I am taken to representative page
