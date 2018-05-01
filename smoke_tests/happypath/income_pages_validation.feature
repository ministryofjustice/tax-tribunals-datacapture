Feature: Page validation on Income Tax
  Background:
    Given I show my environment
    Then I visit "/"
    And I should see "What do you want to do?"
    When I click the "Appeal against a tax decision" link
    Then I should see "Appeal against a tax decision"
    And I click the "Continue" link
    Then I should see "What is your appeal about?"

    Scenario: Error message shown on What is your appeal about? page
      When I click Continue without selecting an option
      Then I should get an error message "Select what your appeal is about"

    Scenario: Error message shown on review of original decision page
      When I am on review of original decision page
      And I should see "Did you appeal the original decision to HMRC?"
      And I click Continue without selecting an option
      Then I should get an error message "Select if you asked for a review of the original decision"

    Scenario: Error message shown on What response did you receive? page
      When I am on What response did you receive page
      And I should see "What response did you receive?"
      And I click Continue without selecting an option
      Then I should get an error message "Select what response you received"

    Scenario: Error message shown on dispute type page
      When I am on dispute type page
      And I should see "What is your dispute about?"
      And I click Continue without selecting an option
      Then I should get an error message "Select what your dispute is about"

    Scenario: Error message shown on penalty amount page
      When I am on the penalty or surcharge amount page
      And I should see "How much is the penalty or surcharge you are disputing?"
      And I click Continue without selecting an option
      Then I should get an error message "Select a penalty or surcharge amount"

    Scenario: Error message shown on are you in time to appeal? page
      When I am on Are you in time to appeal to the tax tribunal page
      And I should see "Are you in time to appeal to the tax tribunal?"
      And I click Continue without selecting an option
      Then I should get an error message "Select whether you are in time to appeal to the tax tribunal"

    Scenario: Error message shown on Are you a taxpayer making the appealpage
      When I am on Are you the taxpayer making the appeal page
      And I should see "Are you the taxpayer making the appeal?"
      And I click Continue without selecting an option
      Then I should get an error message "Select whether you are the taxpayer or acting for them"
