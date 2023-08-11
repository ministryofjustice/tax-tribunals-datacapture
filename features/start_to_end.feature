Feature: Start to end
  # Scenario: Screenshots
  #   Given I take a screenshot of appeal
  #   And I take a screenshot of closure

  @smoke
  Scenario: Completion of a valid closure application
    Given I complete a valid closure application
    Then I should be told that the application has been successfully submitted
    And I click Finish
    Then I should be on the Smart Survey link

  @smoke
  Scenario: Completion of a valid appeal application
    Given I complete a valid appeal application
    Then I should be told that the application has been successfully submitted
    And I click Finish
    Then I should be on the Smart Survey link

  @smoke
  Scenario: Timeout test - shouldn't trigger
    Given I complete a valid appeal application
    Then I should be told that the application has been successfully submitted
    And I wait for 11 minutes
    And I click Finish
    Then I should be on the Smart Survey link