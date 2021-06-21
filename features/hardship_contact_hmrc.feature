Feature: Hardship contact HMRC page

  Background: Contact HMRC page
    Given I create an indirect tax application where HMRC claim I owe money
    And I am on the contact HMRC page

  Scenario: Redirect to HMRC page
    Given I select the button to contact HMRC
    Then I am redirected to that url
  
  Scenario: Return to hardship options
    Then I have a back button

  Scenario: Verify Welsh language link
    When I click on the 'Cymraeg' link
    Then I will see the website open in that language