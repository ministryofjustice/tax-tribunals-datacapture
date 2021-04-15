Feature: Cookies

  Background: I visit the home page
    Given I visit the homepage

  Scenario: Cookie Banner is present
    Then I see the cookie banner is present

  Scenario: Cookie Banner is accepted
    When I accept the cookies
    Then I see the cookie banner is not present

  Scenario: Cookie Banner is accepted
    When I reject the cookies
    Then I see the cookie banner is not present

  Scenario: I accept cookie through the cookie page
    When I click on the Cookies link
    Then I am on the Cookies page
    And I click save settings
