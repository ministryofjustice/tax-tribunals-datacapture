Feature: Save appeal

  Background: An appeal in progress
    Given I have an appeal in progress
    When I click on save and come back later
    Then I am taken to the save your appeal page

    Scenario: Password must be at least 8 characters
      When I enter a password that is not at least 8 characters
      Then I should see an error messages telling me the criteria has not been met
