Feature: Homepage

  Background: Homepage
    Given I visit the homepage
    And I should be asked what do you want to do

  Scenario: Apply to close an enquiry
    When I click the apply to close an enquiry link
    Then I am taken to the closure page

  Scenario: No time estimates on homepage
    Then I should not see tax time information
    And I should not see enquiry time information
