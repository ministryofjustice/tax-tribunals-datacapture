Feature: Closure page

  Background: Closure page
    Given I am on the closure page

  Scenario: Continue closure
    When I click continue to close an enquiry
    Then I am taken to the case type case
