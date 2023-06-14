Feature: In time feature

  Background: Lateness page
    Given I visit the in time page

   Scenario: No selection
    When I click the continue button
    Then I see the selection error

   Scenario: I am in time
     When I choose that i am in time
     Then I am taken to the user type page

  Scenario: I am not in time
    When I select that i am not in time
    Then I am taken to the lateness reason page
    When I choose the file requirements dropdown
    Then I see the dropdown information
    When I click continue
    Then I see the submission error message
    When I enter a valid reason
    Then I am taken to the user type page

  Scenario: I select I am not sure
    When I select that I am not sure
    Then I am taken to the reasons page

  Scenario: I select I am not sure and test virus upload on next page
    When I select that I am not sure
    Then I am taken to the reasons page
    When I upload a virus document on the reasons page
    And I click the continue button
    Then I will see a virus upload error on the reasons page

  Scenario: I select I am not in time and test virus upload on next page
    When I select that i am not in time
    Then I am taken to the lateness reason page
    When I upload a virus document on the reasons page
    And I click the continue button
    Then I will see a virus upload error on the reasons page

  Scenario: Timeout test - should trigger
    When I wait for 11 minutes
    And I click continue
    Then I will see the invalid session timeout error
