Feature: Dispute type options

  Background: Navigating to the dispute type page
    Given I am on the dispute type page

  Scenario: Penalty or surcharge option
    Given I click the penalty or surcharge option and submit
    When I click the continue button
    Then I should see a select penalty or surcharge amount error
    When I select 100 to 20000 option and submit
    Then I should see an enter penalty amount error
    When I submit a penalty amount value
    Then I should be on the lateness page

  Scenario: Repay or owe HMRC option
    Given I click HMRC repay option and submit
    When I click the continue button
    Then I should see an enter the tax amount error
    When I submit a tax amount value
    Then I should be on the lateness page

  Scenario: Owe money and a penalty or surcharge option
    Given I click owe money and a penalty or surcharge option and submit
    When I click the continue button
    Then I should see two penalty and tax amount errors
    When I submit both tax and penalty amount values
    Then I should be on the lateness page

  Scenario: PAYE option
    Given I click PAYE option and submit
    Then I should be on the lateness page

  Scenario: None of the above option
    Given I click none of the above option and submit
    Then I should see please enter an answer error
    When I submit what my dispute is about
