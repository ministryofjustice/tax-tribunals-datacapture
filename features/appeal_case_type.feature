Feature: Appeal case type page

  Background: Appeal case type page
    Given I am on the appeal case type page
  
  Scenario: Error message
    When I click on continue without selecting a case type
    Then I should be on the appeal case type page
    And I should see error message

  Scenario: Successful step (Income tax)
    When I click on continue after selecting Income Tax option
    Then I should go to the challenge decision page

  Scenario: Successful step (Capital gains)
    When I click on continue after selecting capital gains option
    Then I should go to the challenge decision page

  Scenario: Successful step (Other)
    When I click on continue after selecting Other option
    Then I should go to the case type show more page

  Scenario: No selection on the case type show more page
    When I click on continue after selecting Other option
    And I am on the case type show more page
    And I click on continue without selecting a case type
    Then I should see error message

  Scenario: Selection provided on the case type show more page
    When I click on continue after selecting Other option
    And I am on the case type show more page
    And I click on continue after selecting Aggregates Levy option
    Then I should go to the challenge decision page

  Scenario: No detail provided to None of the above option
    When I click on continue after selecting Other option
    And I am on the case type show more page
    And I click on None of the above option
    And I click on continue without providing an answer
    Then I should see answer error message

  Scenario: Detail is provided to None of the above option
    When I click on continue after selecting Other option
    And I am on the case type show more page
    And I click on None of the above option
    And I click on continue after providing an answer
    Then I should go to the in time page