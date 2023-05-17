Feature: Homepage

  Background: Homepage
    Given I visit the homepage

  Scenario: Appeal against a tax decision
    When I click the appeal a tax decision
    Then I am taken to the appeal page

  Scenario: Apply to close an enquiry
    When I click the apply to close an enquiry link
    Then I am taken to the closure page

  Scenario: No time estimates on homepage
    Then I should not see tax time information
    And I should not see enquiry time information

  Scenario: Return to a saved appeal or application
    When I click the return to a saved appeal button
    Then I am taken to the login page

  Scenario: View guidance page
    When I click the view guidance before I start link
    Then I am taken to the guidance page

  Scenario: Timeout test - shouldn't trigger
    When I wait for 11 minutes
    And I click the appeal a tax decision
    Then I am taken to the appeal page
