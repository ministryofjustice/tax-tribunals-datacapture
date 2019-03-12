@smoke

Feature: Closure page

  Background: Closure page
    Given I am on the closure page

  Scenario: Continue closure
    When I click continue to close an enquiry
    Then I should see "What type of enquiry do you want to close?"