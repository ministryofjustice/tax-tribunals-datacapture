Feature: Taxpayer type page

  Background: Taxpayer type page
    Given I am on the taxpayer type page

    Scenario: I am the tax payer making the application
      When I submit that I am an individual
      Then I am taken to the taxpayer details page
