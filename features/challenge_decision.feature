Feature: Did you appeal the original decision (page both closure and appeal)

Background: Appeal decision question page
    Given I am on the challenge decision page

  Scenario: Select No
    When I select no
    Then I am taken to the must appeal decision status page

  Scenario: No option chosen
    When I continue with no option selected
    Then I see the problem error message
    And I am still on the challenge decision page

  Scenario: Path to dispute type page (review conclusion letter)
    When I select yes
    Then I am taken to the challenge decision status page
    When I select I have a review conclusion letter
    Then I should be on the dispute type page

  Scenario: Challenge decision page error and less than 45 days
    When I select yes
    Then I am taken to the challenge decision status page
    When I press continue with no response selected
    Then I will see the error response
    And I will still be on the decision status page
    When I select I have been waiting less than fourty five days
    Then I should be taken to the must wait for challenge decision page

  Scenario: Late appeal
    When I select yes
    Then I am taken to the challenge decision status page
    When I select my appeal to HMRC was late
    Then I am taken to the are you in time page

  Scenario: I press 'Help with challenging a decision'
    When I press 'Help with challenging a decision'
    Then I will see the drop down list
    When I press 'challenge a tax decision with HM Revenue and Customs'
    Then I will be on the gov 'tax-appeals' page

  Scenario: UK border force
    When I press 'Help with challenging a decision'
    And I press 'options when UK border force seizes your things'
    Then I will be on the gov 'customs-seizures' page

  Scenario: NCA
    When I press 'Help with challenging a decision'
    And I press how to 'challenge a national crime agency'
    Then I will be on the appeal home page

  Scenario: Timeout test - should trigger
    When I wait for 11 minutes
    And I click continue
    Then I will see the invalid session timeout error
