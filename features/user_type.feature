Feature: User type page

  Background: User type page
    Given I navigate to closure user type page

  Scenario: I am the tax payer making the application
    When I click the continue button
    Then I should see the taxpayer_error
    When I click on the information dropdown
    Then I shall see the what is a representative information
    When I submit that I am the tax payer making the application
    Then I am taken to the taxpayer type page

  Scenario: I am not the tax payer making the application
    When I submit that I am not the tax payer making the application
    Then I am taken to the representative type page

