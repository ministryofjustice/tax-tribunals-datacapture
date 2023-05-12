Feature: Send details
  Scenario: Started by taxpayer and send to taxpayer and representative
    Given I navigate to the send taxpayer copy page as the taxpayer
    And I select yes and submit a valid email on the send taxpayer copy page
    And I submit that I have a representative
    And I submit that the representative is a practising solicitor
    And I submit that the representative is an individual
    And I successfully submit representative details without email
    Then I should see a blank email error
    And I successfully submit representative details with email
    When I submit an email that doesn't match on the send representative copy page
    Then I should see not matching email error
    Given I go back to representative details page and add an email address and submit
    When I submit an email that does match on the send representative copy page
    Then I should be on the enquiry details page

  Scenario:
    Given Given I navigate to the send taxpayer copy page as the taxpayer
    When I click the continue button
    Then I see the error
    When I submit no
    Then I am on the has representative page

  Scenario: Timeout test - should trigger
    Given I navigate to the send taxpayer copy page as the taxpayer
    When I wait for 11 minutes
    And I click the continue button
    Then I will see the invalid session timeout error
