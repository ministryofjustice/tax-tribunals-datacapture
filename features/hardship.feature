Feature: Hardship journey

  Scenario: Direct tax (Income) and HMRC claim I owe money application
    Given I create a direct tax application where HMRC claim I owe money
    When I submit a tax amount value
    Then I should be on the lateness page

  Scenario: Direct tax (Income) and penalty application
    Given I create a direct tax application about a penalty
    When I submit a penalty amount value
    Then I should be on the lateness page

  Scenario: Indirect tax (VAT) and HMRC claim I owe money application
    Given I create an indirect tax application where HMRC claim I owe money
    When I submit a tax amount value
    And I submit that I have not paid the tax under dispute
    And I submit that I have asked HMRC if I could appeal to tribunal
    And I submit that HMRC did not allow me to defer paying
    And I submit a reason for financial hardship
    Then I should be on the lateness page

  Scenario: Indirect tax (VAT) and penalty application
    Given I create an indirect tax application about a penalty
    When I submit a penalty amount value
    Then I should be on the lateness page

  Scenario: Yes I have paid the amount of tax under dispute
    Given I create an indirect tax application where HMRC claim I owe money
    When I submit a tax amount value
    And I submit that I have paid the tax under dispute
    Then I should be on the lateness page

  Scenario: No hardship review requested
    Given I create an indirect tax application where HMRC claim I owe money
    When I submit a tax amount value
    And I submit that I have not paid the tax under dispute
    And I submit that I have not asked HMRC if I could appeal to tribunal
    Then I should be on the contact HMRC page

  Scenario: Yes HMRC allowed me to defer paying because of financial hardship
    Given I create an indirect tax application where HMRC claim I owe money
    When I submit a tax amount value
    And I submit that I have not paid the tax under dispute
    And I submit that I have asked HMRC if I could appeal to tribunal
    And I submit that HMRC did allow me to defer paying
    Then I should be on the lateness page
