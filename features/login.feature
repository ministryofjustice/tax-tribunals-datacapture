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

  Scenario: Forgot your password?
    When I click the 'Forgot your password?' link
    Then I will be on the 'Forgot your password' page
    When I click the reset button password without an email
    Then I will see a blank email error message
    When I click the go back link
    Then I should see the sign in page

  Scenario: Timeout test - shouldn't trigger
    When I wait for 11 minutes
    And I click sign in
    Then I will not see the invalid timeout error
