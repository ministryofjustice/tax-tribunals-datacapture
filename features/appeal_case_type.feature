Feature: Appeal case type page

  Background: Appeal case type page
    Given I am on the appeal case type page

  #Scenario: Error message
   # When I click on continue without selecting an option
   # Then I should be on the appeal case type page
   # And I should see appeal case type error message

  Scenario: Successful step (Income tax)
    When I click on continue after selecting Income Tax option
    And I select nothing then english only
    Then I should be on the appeal challenge decision page

  Scenario: Successful step (Other)
    When I click on continue after selecting Other option
    Then I am on the case type show more page

  Scenario: No selection on the case type show more page
    When I click on continue after selecting Other option
    And I am on the case type show more page
    And I click on continue without selecting an option
    Then I should see appeal case type error message

  Scenario: Selection provided on the case type show more page
    When I click on continue after selecting Other option
    And I am on the case type show more page
    And I click on continue after selecting Aggregates Levy option
    Then I should be on the review challenge decision page

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
    Then I should be on the lateness page
