Feature: Closure Happy Path
  Background:
    Given I show my environment
    Then I visit "/"
    And I should see "What do you want to do?"
    When I click the "Apply to close an enquiry" link
    Then I should see "Apply to close an enquiry"
    And I click the "Continue" link
    Then I should see "What type of enquiry do you want to close?"

  @happy_path
  Scenario: Personal return application Happy Path
    Given I choose "Personal return"
    Then I should see "Are you the taxpayer making the application?"

    Given I choose "Yes"
    Then I should see "Who is making the application?"

    Given I choose "Individual"
    Then I should see "Enter taxpayer's details"

    Given I fill in "First name" with "MoJ Digital"
    And I fill in "Last name" with "Smoketest"
    And I fill in "Address" with "102 Petty France"
    And I fill in "Postcode" with "SW1H 9AJ"
    And I fill in "Email address" with "do-not-email@digital.justice.gov"
    And I click the "Continue" button
    Then I should see "Do you have someone to represent you?"

    Given I choose "No"
    Then I should see "Enquiry details"

    Given I fill in "HMRC reference number" with "12345"
    And I fill in "Years under enquiry" with "3 and a half"
    And I click the "Continue" button
    Then I should see "Why should the enquiry close? (optional)"

    Given I fill in "Enter reasons (optional)" with "My very sensible reasons."
    And I click the "Continue" button
    Then I should see "Add documents to support your application (optional)"

    Given I drop "original_notice.docx"
    Then I should see "original_notice.docx"
    And I should not see "format we don't accept"
    And I should not see "Server responded with 0 code"
    And I should not see "No files uploaded"

    Given I click the "Remove" link
    Then I should not see "original_notice.docx"

    Given I drop "original_notice.docx"
    Then I should see "original_notice.docx"
    And I should not see "format we don't accept"
    And I should not see "Server responded with 0 code"
    And I should not see "No files uploaded"

    Given I drop "review_conclusion.docx"
    Then I should see "review_conclusion.docx"
    And I should not see "format we don't accept"
    And I should not see "Server responded with 0 code"
    And I should not see "No files uploaded"

    # There is an intermittent S3 race condition where the last upload before
    # 'Check your answers' does not get stored in time to make it into the list
    # call of 'Check your answers'.
    Given I pause for "2" seconds

    When I click the "Continue" button
    Then I should see "Check your answers"
    And I should see "Enquiry details"
    And I should see "original_notice.docx"
    And I should see "review_conclusion.docx"

    Given I click the "Submit" button
    Then I should see "Case submitted"
    And I should see "Your case reference number is:"
    And I see a case reference number
