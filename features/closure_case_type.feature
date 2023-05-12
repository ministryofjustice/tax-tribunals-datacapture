Feature: Case type page

  Background: Case type page
    Given I am on the closure case type page

  Scenario: Displays hint
    Then I should see that I can only close one of the listed options

  Scenario: Personal return
    When I submit that it is a personal return
    Then I should be on the closure user type page

  Scenario: I press continue with no option selected
    When I press continue with nothing selected
    Then The error should appear

  Scenario: Timeout test - shouldn't trigger
    When I wait for 11 minutes
    And I click continue
    Then The error should appear
