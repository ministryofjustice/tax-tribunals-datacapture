Feature: Taxpayer type page

  Background: Taxpayer type page
    Given I am on the taxpayer type page

  Scenario: I am the tax payer making the application
    When I click the continue button
    Then I will see an error message
    When I submit that I am an individual
    Then I am taken to the taxpayer details page

  Scenario: I am the company making the application
    When I submit that I am a company
    Then I am taken to the taxpayer details page

  Scenario: I am an organisation making the application
    When I submit that I am an other
    Then I am taken to the taxpayer details page

  Scenario: Timeout test - should trigger
    When I wait for 11 minutes
    And I click the continue button
    Then I will see the invalid session timeout error