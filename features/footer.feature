Feature: Footer

  Background: I am on the home page
    Given I visit the homepage

  Scenario: Help link
    Then I am able to click on the external Help link

  Scenario: Contact link
    When I click on the Contact link
    Then I am on the Contact page

  Scenario: Cookies link
    When I click on the Cookies link
    Then I am on the Cookies page

  Scenario: Terms and conditions link
    When I click on the Terms and conditions link
    Then I am on the Terms and conditions page

  Scenario: Privacy policy link
    When I click on the Privacy policy link
    Then I am on the Privacy policy page

  Scenario: Accessibility statement link
    When I click on the Accessibility statement link
    Then I am on the Accessibility statement page
