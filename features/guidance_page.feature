Feature: Guidance page

  Background: Guidance page
    Given I visit the guidance page

  Scenario: Click back
    Given I click the back button
    Then I am on the home page

  Scenario: Accordion unexpanded
    Then I can only see a question and not the answer

  Scenario: Accordion one expanded
    When I click a question
    Then I can see a question and the answer

  Scenario: Accordion all expanded
    When I click open all
    Then I can see all questions and answers
    