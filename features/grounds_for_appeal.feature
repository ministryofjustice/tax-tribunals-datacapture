Feature: Grounds for Appeal

  Background: Navigate to grounds for appeal page
    Given I navigate to the has grounds for appeal page

  Scenario: Invalid then valid text submission
    When I press continue with nothing entered
    Then I should see the empty page error
    When I submit a response with text entered
    Then I can navigate to the details-pathway eu exit page
    When I click the continue button
    Then I am on the outcome page
    When I complete a blank then valid submission
    Then I am on the need support page
    When I click the continue button
    Then I should see the support selection error
    When I submit no support needed
    Then I should be on the letter upload page

  Scenario: File uploaded information span selected then valid submission
    When I select 'File upload requirements'
    Then I will see the file requirements
    When I then upload a valid file type
    Then I can navigate to the details-pathway eu exit page
    When I submit no and then yes
    Then I am on the outcome page
    When I complete a valid submission
    Then I am on the need support page
    When I submit yes
    Then I should be on the what support page

  Scenario: Virus file upload test
    When I upload a virus document on the grounds for appeal page
    Then I will see a virus upload error on the grounds for appeal page
#  This functionality on the page has been tested manually but this scenario fails

  Scenario: Timeout test - should trigger
    When I wait for 11 minutes
    And I press continue with nothing entered
    Then I will see the invalid session timeout error
