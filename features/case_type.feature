Feature: Case type page

  Background: Case type page
    Given I am on the case type page

    Scenario: Displays hint
      Then I should see that I can only close one of the listed options

    Scenario: Personal return
      When I submit that it is a personal return
      Then I am taken to the user type page
