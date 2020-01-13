Feature: Save appeal

  Background: An appeal in progress
    Given I have an appeal in progress
    When I click on save and come back later
    Then I am taken to the save your appeal page

    Scenario: Password must be at least 8 characters
      When I enter a password that is not at least 8 characters
      Then I should see a password error messages

    Scenario: Password must have at least one number
      When I enter a password that does not have at least one number
      Then I should see a password error messages

    Scenario: Password must have at least one uppercase and one lowercase letter
      When I enter a password that does not have an upper and lower case
      Then I should see a password error messages

    Scenario: Password must have at least one special character
      When I enter a password that does not have a special character
      Then I should see a password error messages

    Scenario: Password can not be the same with the email address field
      When I enter a password that is the same as my email address
      Then I should see a password error messages

    Scenario: Successfully create an account
      When I enter a valid email address
      And I enter a valid password
      Then I should be taken to the saved confirmation page
