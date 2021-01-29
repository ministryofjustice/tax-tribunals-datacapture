Feature: Logging in

  Background: Navigate to login page
    Given I navigate to the login page

  Scenario: Blank sign in
    Given I click sign in
    Then I should see a blank email error message
    And I should see a blank password error message
    And I should not have logged in

  Scenario: Invalid sign in
    Given I fill in invalid log in details
    Then I should see an invalid email and password error message
    And I should not have logged in