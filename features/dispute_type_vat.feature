Feature: Dispute type options for VAT

  Background: Navigating to the dispute type page
    Given I am on the dispute type page through vat

  Scenario: Notice Of Requirement option
    Given I click notice of requirement option and submit
    Then I should be on the lateness page

  Scenario: Registration option
    Given I click registration option and submit
    Then I should be on the lateness page