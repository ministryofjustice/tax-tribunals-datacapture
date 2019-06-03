Feature: Appeal case type page

  Background: Appeal case type page
    Given I am on the appeal case type page
  
  Scenario: Error message
    When I click on continue without selecting a case type
    Then I should see error message
