Feature: Feedback page

  Background: Feedback page
    Given I am on the feedback page

    Scenario: Submit feedback
      When I successfully submit my feedback
      Then I am taken to a thank you page
      And I click continue
      Then I am taken to the homepage

    Scenario: Error messages
      When I submit a blank form
      Then I should see error messages for the mandatory fields
