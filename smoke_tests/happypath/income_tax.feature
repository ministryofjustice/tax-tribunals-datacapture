Feature: Income Tax Happy Paths
  Background:
    Given I show my environment
    Then I visit "/"
    And I should see "What do you want to do?"
    When I click the "Appeal against a tax decision" link
    Then I should see "Appeal against a tax decision"
    And I click the "Continue" link
    Then I should see "What is your appeal about?"

  @happy_path
  Scenario: Individual Income Tax Happy Path
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
    Given I click the "Resume" link
    Then I should see "Resume your appeal"
    Given I click the "Resume appeal" link

    Then I should see "What is your dispute about?"
    Given I choose "Penalty or surcharge"
    Then I should see "How much is the penalty or surcharge you are disputing?"

    Given I choose "£100 or less"
    Then I should see "Are you in time to appeal to the tax tribunal?"

    Given I choose "Yes, I am in time"
    Then I should see "Are you the taxpayer making the appeal?"

    Given I choose "Yes"
    Then I should see "Who is making the appeal?"

    Given I choose "Individual"
    Then I should see "Enter taxpayer's details"

    Given I fill the contact details
    And I click the "Save and continue" button
    Then I should see "Do you have someone to represent you?"

    Given I choose "No"
    Then I should see "Grounds for appeal"

    Given I attach a file explaining my grounds
    When I click the "Save and continue" button
    And I pause for "2" seconds
    And I click the "Back" link
    Then I should see "Previously attached document: grounds_for_appeal.docx"
    And I click the "Remove" button
    Then I should not see "grounds_for_appeal.docx"

    Given I attach a file with a virus
    And I click the "Save and continue" button
    Then I should see "eicar.com.txt has a virus"

    Given I attach a file explaining my grounds
    Then I click the "Save and continue" button
    And I pause for "2" seconds
    And I click the "Back" link
    Then I should see "Previously attached document: grounds_for_appeal.docx"
    And I click the "Save and continue" button
    Then I should see "Briefly say what outcome you would like"

    Given I fill in "Clearly explain in 2-3 sentences" with "Drive my enemies before me, hear the lament of their women"
    And I click the "Save and continue" button

    Then I should see "Do you need any support at the hearing?"
    When I click the radio button "Yes"
    And I click the "Save and continue" button
    Then I should see "Support at the hearing"
    When I click the radio button "Language interpreter"
    And I fill in "What language needs to be interpreted?" with "Spanish"
    And I click the radio button "Sign language interpreter"
    And I fill in "Enter the sign language you need" with "Spanish"
    And I click the radio button "Other support"
    And I fill in "Explain what other support you will need at your tribunal" with "Step-free access"
    And I click the "Save and continue" button

    Then I should see "Upload the review conclusion letter"

    Given I choose "Upload the letter as multiple pages"
    Then I should see "Upload the review conclusion letter"
    And I should see "Drag and drop files here"

    # Dropzone uploader
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

    When I click the "Save and continue" button
    Then I should see "Check your answers"
    And I should see "Appeal details"
    And I should see "London, SW1H 9AJ"
    And I should see "grounds_for_appeal.docx"

    And I should see "Do you need any support at the hearing?"
    And I should see "Language interpreter"
    And I should see "Spanish"
    And I should see "Sign language interpreter"
    And I should see "Spanish"
    And I should see "Other support"
    And I should see "Step-free access"

    And I should see "Letter uploaded"
    And I should see "original_notice.docx"
    And I should see "review_conclusion.docx"

    Given I click the "Submit" button
    Then I should see "Case submitted"
    And I should see "Your case reference number is:"
    And I see a case reference number
