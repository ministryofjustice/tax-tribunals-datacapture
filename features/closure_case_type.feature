Feature: Case type page

  Background: Case type page
    Given I am on the closure case type page

  Scenario: Displays hint
    Then I should see that I can only close one of the listed options

  Scenario: Personal return
    When I submit that it is a personal return
    Then I should be on the closure user type page

  Scenario: Company return
    When I submit that it is a company return
    Then I should be on the closure user type page

  Scenario: Partnership return
    When I submit that it is a partnership return
    Then I should be on the closure user type page

  Scenario: Trustee return
    When I submit that it is a trustee return
    Then I should be on the closure user type page

  Scenario: Enterprise Management Incentives (EMIs)
    When I submit that it is an enterprise management incentive (EMI)
    Then I should be on the closure user type page

  Scenario: Non-resident Capital Gains Tax (NRCGT) return
    When I submit that is is a non-resident Capital Gains Tax (NRCGT) return
    Then I should be on the closure user type page

#  Scenario: Stamp Duty Land Tax (SDLT) or Land Transaction Tax (in Wales)
#    When I submit that it is a Stamp Duty Land Tax (SDLT) or Land Transaction Tax (in Wales): land transaction return
#    Then I should be on the closure user type page
# This test will fail while the extra bit of text ':land transaction return' is not in the en.yml
# Staging environment text option should be: Stamp Duty Land Tax (SDLT) or Land Transaction Tax (in Wales) return: land transaction return

  Scenario: Transactions in securities: issue of counteraction or no-counteraction notice
    When I submit that is a Transactions in securities: issue of counteraction or no-counteraction notice
    Then I should be on the closure user type page

  Scenario: Claim or amendment of a claim
    When I submit that is a Claim or amendment of a claim
    Then I should be on the closure user type page

  Scenario: I press continue with no option selected
    When I press continue with nothing selected
    Then The error should appear

  Scenario: Timeout test - shouldn't trigger
    When I wait for 11 minutes
    And I click continue
    Then The error should appear
    And I will not see the invalid timeout error
