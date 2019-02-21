@smoke

Feature: Homepage

   Background: Homepage
     Given I visit the homepage
     And I should see "What do you want to do?"

  Scenario: Apply to close an enquiry
    When I click the apply to close an enquiry link
    Then I should see "Apply to close an enquiry"
