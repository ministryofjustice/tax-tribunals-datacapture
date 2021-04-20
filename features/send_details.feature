Feature: Send details
@test
  Scenario: Started by taxpayer and send to taxpayer and representative
    Given I navigate to the send taxpayer copy page as the taxpayer
    And I select yes and submit a valid email on the send taxpayer copy page
    And I submit that I have a representative
    And I submit that the representative is a practising solicitor
    And I submit that the representative is an individual
    And I successfully submit representative details without email
    When I submit yes and submit blank email field
    Then I should see a blank email error
    When I submit an email that doesn't match on the send representative copy page
    Then I should see not matching email error
    Given I go back to representative details page and add an email address and submit
    When I submit an email that does match on the send representative copy page
    Then I should be on the enquiry details page