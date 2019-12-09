Feature: Feedback page

  Background: Feedback page
    Given I am on the feedback page

    Scenario: Error messages
      When I submit a blank form
      Then I should see error messages for the mandatory fields
