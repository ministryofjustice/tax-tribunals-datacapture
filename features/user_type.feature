Feature: User type page

  Background: User type page
    Given I am on the user type page

    Scenario: I am the tax payer making the application
      When I submit that I am the tax payer making the application
      Then I am taken to the taxpayer type page
