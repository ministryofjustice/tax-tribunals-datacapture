@saucelabs
Feature: Start to end
  # Scenario: Screenshots
  #   Given I take a screenshot of appeal
  #   And I take a screenshot of closure

  Scenario: Completion of a valid closure application
    Given I complete a valid closure application
    Then I should be told that the application has been successfully submitted
    And I click Finish
    Then I should be on the Smart Survey link

  Scenario: Completion of a valid appeal application
    Given I complete a valid appeal application
    Then I should be told that the application has been successfully submitted
    And I click Finish
    Then I should be on the Smart Survey link
