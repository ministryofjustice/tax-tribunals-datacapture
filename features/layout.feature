Feature: Layout

  Background: I am on the home page
    Given I visit the homepage

  Scenario: Verify Smart Survey link
    Then I am able to click on the Smart Survey link

  Scenario: Verify help link
    Then I am able to click on the external Help link

  Scenario: Verify contact link
    When I click on the Contact link
    Then I am on the Contact page

  Scenario: Verify cookies link
    When I click on the Cookies link
    Then I am on the Cookies page

  Scenario: Verify terms and conditions link
    When I click on the Terms and conditions link
    Then I am on the Terms and conditions page

  Scenario: Verify privacy policy link
    When I click on the Privacy policy link
    Then I am on the Privacy policy page

  Scenario: Verify accessibility statement link
    When I click on the Accessibility statement link
    Then I am on the Accessibility statement page

  Scenario: Verify Welsh language selector link
    When I click on the 'Cymraeg' link
    Then I am on the 'cy' locale

  Scenario: Verify English language selector link
    When I click on the 'Cymraeg' link
    And I click on the 'English' link
    Then I am on the 'en' locale
