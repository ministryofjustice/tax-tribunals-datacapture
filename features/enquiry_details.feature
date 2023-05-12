Feature: Enquiry details

  Background: Navigate to the enquiry details page
    Given I am on the enquiry details page

  Scenario: Invalid then valid submission
    When I click the continue button
    Then I should see two enquiry details errors
    When I fill in the two required fields and submit
    Then I should be on the additional info page

  Scenario: Timeout test - should trigger
    When I wait for 11 minutes
    And I click continue
    Then I will see the invalid session timeout error
