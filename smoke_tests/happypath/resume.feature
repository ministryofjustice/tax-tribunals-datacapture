Feature: Resume to continue existing application

  Background:
    Given I show my environment
    Then I visit "/"
    And I should see "What do you want to do?"
    When I click the "Appeal against a tax decision" link
    Then I should see "Appeal against a tax decision"
    And I click the "Continue" link
    Then I should see "What is your appeal about?"
    Given I choose "Income Tax"
    Then I should see "Did you appeal the original decision to HMRC?"

    Given I choose "Yes"
    And I choose "I have a review conclusion letter"
    Then I should see "What is your dispute about?"

    Given I click the "Save and come back later" link
    And I fill in my email address
    And I fill in "Choose password" with "ABCD1234"
    When I click the "Save" button
    Then I should see "Your case has been saved"
    Given I click the "Sign in" link
    And I fill in my email address
    And I fill in "Enter password" with "ABCD1234"
    When I click the "Sign in" button
    Then I should see "Your saved cases"


    Scenario: check that existing application can be deleted
      When I click the "Delete" button
      And I accept alert
      Then I should not see pending application

    Scenario: Check that you can add a refrence code to an existing application
      When I click the "Add a reference" link
      And I fill in "Your reference (optional)" with "test123"
      And I click the "Continue" button
      Then I should see the reference "test123" on page

    Scenario: Verify that you are redirected to the last left page
      When I click the "Resume" link
      And I click on the "Resume application" link
      Then I should see "Did you appeal the original decision to HMRC?"
