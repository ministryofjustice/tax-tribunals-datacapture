Feature: One email required

  Background: Go to closure user type page
    Given I navigate to closure user type page

  Scenario: Started by taxpayer with representative
    Given I submit that I am the tax payer making the application
    And I submit that I am an individual
    When I submit a blank taxpayers details form
    Then I should see a blank email error
    When I successfully submit taxpayers details
    And I submit that I don't want a copy of the case details emailed to the taxpayer
    And I submit that I have a representative
    And I submit that the representative is a practising solicitor
    And I submit that the representative is an individual
    And I submit a blank representative details form
    Then I should see a blank email error

  Scenario: Started by representative
    Given I submit that I am not the tax payer making the application
    And I submit that the representative is a practising solicitor
    And I submit that I am an individual
    When I submit a blank representative details form
    Then I should see a blank email error
    When I successfully submit representative details with email
    And I submit that I don't want a copy of the case details emailed to the representative
    And I submit that I am an individual
    When I submit a blank taxpayers details form
    Then I should not see an email error