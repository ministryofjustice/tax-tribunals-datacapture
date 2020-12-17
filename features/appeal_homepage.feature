Feature: Start an appeal

  Background: Appeal home page
    Given I am on the appeal homepage page

  Scenario: Start appeal
    When I appeal against a tax decision
    Then I am taken to the appeal case type page
