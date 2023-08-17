Feature: Taxpayer details page

  Background: Taxpayer details page
    Given I navigate to the closure taxpayer details page as a taxpayer

  Scenario: Successfully submit taxpayer details
    When I successfully submit taxpayers details
    Then I am taken to the send taxpayer copy page

  Scenario: Unsuccessfully submit taxpayer details
    When I submit a blank taxpayers details form
    Then I am shown all the taxpayer details errors
    And I am on the taxpayer details page

  Scenario: Submitting invalid details
    When I submit a taxpayers details form with an invalid email
    Then I am shown an invalid email error
    And I am on the taxpayer details page
    When I re-submit a valid email
    Then I am taken to the send taxpayer copy page

  Scenario: Submitting no phone number validation error check (email and text)
    When I submit a taxpayers details form with no phone number
    And I am taken to the send taxpayer copy page
    And I select both email and text message and fill in an email
    Then I am shown a blank phone error
    And I am on the send taxpayer copy page

  Scenario: Submitting no phone number validation error check (text)
    When I submit a taxpayers details form with no phone number
    And I am taken to the send taxpayer copy page
    And I select text message and try and proceed with a blank number
    Then I am shown a blank phone error
    And I am on the send taxpayer copy page

  Scenario: Submitting phone number and triggering non matching phone number error (email and text)
    When I successfully submit taxpayers details
    And I am taken to the send taxpayer copy page
    And I select both email and text message and fill in an email and a non matching phone number
    Then I am shown a blank phone error

  Scenario: Submitting phone number and triggering non matching phone number error (text)
    When I successfully submit taxpayers details
    And I am taken to the send taxpayer copy page
    And I select text message and fill in an email and a non matching phone number
    Then I am shown a blank phone error

  Scenario: Timeout test - should trigger
    When I wait for 11 minutes
    And I submit a blank taxpayers details form
    Then I will see the invalid session timeout error