Feature: Enquiry details

  Background: Navigate to the enquiry details page
    Given I am on the enquiry details page

  Scenario: Invalid then valid submission
    When I click the continue button
    Then I should see two enquiry details errors
    When I fill in the two required fields and submit
    Then I should be on the additional info page

  Scenario: Additional info page virus testing
    When I fill in the two required fields and submit
    And I upload a virus document to the additional info page
    And I click the continue button
    Then I will see a virus upload error on the additional info page
#  This functionality on the page has been tested manually but this scenario fails

  Scenario: Timeout test - should trigger
    When I wait for 11 minutes
    And I click continue
    Then I will see the invalid session timeout error
