Feature: Hardship journey

  Background: User is taken to the hardship steps
    Given I am taken to the disputed tax paid step

  # For some reason this scenario won't work using headless driver
  @apparition
  Scenario: Touch all 4 hardship steps
    When I submit that I have not paid the tax under dispute
    And I submit that I have asked HMRC if I could appeal to tribunal
    And I submit that HMRC did not allow me to defer paying
    And I submit a reason for financial hardship
    Then I am on in time page

