@smoke @headless

Feature: Closure Happy Path
  Background:
    Given I visit the homepage
    When I click the apply to close an enquiry link
  
    And I click continue to close an enquiry
    Then I should see "What type of enquiry do you want to close?"

  Scenario: Personal return application Happy Path
    Given I choose "Personal return"
    Then I should see "Are you the taxpayer making the application?"

    Given I choose "Yes"
    Then I should see "Who is making the application?"

    Given I choose "Individual"
    Then I should see "Enter taxpayer's details"

    Given I fill in taxpayers details
    And I continue
    Then I should see "Do you have someone to represent you?"

    Given I choose "No"
    Then I should see "Enquiry details"

    Given I successfully submit enquiry details
    Then I should see "Why should the enquiry close? (optional)"

    Given I should be taken to additional info on why the enquiry should be closed
    And I fill in my reason
    And I click continue
    Then I should see "Add documents to support your application (optional)"

    Given I drop "original_notice.docx"
    Then I should see "original_notice.docx"
    And I should not see dropzone errors

    Given I click the "Remove" link
    Then I should not see "original_notice.docx"

    Given I drop "original_notice.docx"
    Then I should see "original_notice.docx"
    And I should not see dropzone errors

    Given I drop "review_conclusion.docx"
    Then I should see "review_conclusion.docx"
    And I should not see dropzone errors

    # There is an intermittent S3 race condition where the last upload before
    # 'Check your answers' does not get stored in time to make it into the list
    # call of 'Check your answers'.
    Given I pause for "2" seconds

    When I click continue
    Then I should see "Check your answers"
    And I should see "Enquiry details"
    And I should see address
    And I should see "original_notice.docx"
    And I should see "review_conclusion.docx"

    Given I click the "Submit" button
    And I pause for "5" seconds
    Then I should see "Case submitted"
    And I should see "Your case was submitted successfully."
    And I should see "You will be sent a case reference number shortly."
