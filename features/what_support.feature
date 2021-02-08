Feature: What support page

  Background: Navigating to the what support page
    Given I am on the what support page

  Scenario: Submit empty form
    When I click on continue without selecting an option
    Then I should see the what support blank error

  Scenario: Select all but don't fill in
    When I click all of the what support checkboxes
    And I click the continue button
    Then I should see three what support blank text errors

  Scenario: Submit a valid form
    When I click all of the what support checkboxes
    And I fill in the three what support textboxes and submit
    Then I should be on the letter upload page