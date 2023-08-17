Feature: Representative Path

  Background: Navigate to representative page
    Given I navigate to the has representative page

  Scenario: When I select nothing then no representative
    When I click the drop down information bar
    Then I will see the information provided
    When I select nothing
    Then I see the selection error message
    When I select no
    Then I see the grounds for appeal page
    #must have moj file uploader running to access ground page

  Scenario: Have representation
    When I select yes
    Then I see the representative professional status page
    When I select nothing
    Then I am shown the no representative professional selection error
    Then I select that the representative is a solicitor
    Then I am taken to the representative type page
    When I select nothing
    Then I am shown the no representative selection error
    When I select that the representative is an individual
    Then I am taken to the representative details (individual) page
    When I select nothing
    Then I will see the pages error messages
    When I fill in the details and progress to the representative copy page
    When I select nothing and see the error messages
#    When I press yes and enter a invalid then valid email
    When I enter an invalid non matching email address
    Then I will see the error response
    Then I enter a valid matching email address
#    Then I see the grounds for appeal page

  Scenario: Representative type page alternative route
    When I advance to the representative professional status page
    And I select that the representative is a tax agent
    Then I am taken to the authorise representative page
    When I select the two information dropdowns
    Then I will see the additional information and move to the next page
    When I select that the representative is a company then that is 'other'
    #must have moj file uploader running to access ground page

  Scenario: Directed to the representative approval page - other
    When I navigate to the authorise representative page
    And I upload a file and continue to the representative type page
    And submit that my representation is other
    Then I am taken to the representative details page (other)

  Scenario: Submitting no phone number validation error check (email and text)
    When I select yes
    Then I see the representative professional status page
    And I select that the representative is a solicitor
    And I select that the representative is an individual
    Then I am taken to the representative details (individual) page
    And I fill in the details without a phone number and progress to the representative copy page
    Then I select both email and text message and fill in an email
    And I am shown a blank phone error

  Scenario: Submitting no phone number validation error check (text)
    When I select yes
    Then I see the representative professional status page
    And I select that the representative is a solicitor
    And I select that the representative is an individual
    Then I am taken to the representative details (individual) page
    And I fill in the details without a phone number and progress to the representative copy page
    Then I select text message and try and proceed with a blank number
    And I am shown a blank phone error

  Scenario: Submitting phone number and triggering non matching phone number error (email and text)
    When I select yes
    Then I see the representative professional status page
    And I select that the representative is a solicitor
    And I select that the representative is an individual
    Then I am taken to the representative details (individual) page
    And I fill in the details and progress to the representative copy page
    And I select both email and text message and fill in an email and a non matching phone number
    Then I am shown a blank phone error

  Scenario: Submitting phone number and triggering non matching phone number error (text)
    When I select yes
    Then I see the representative professional status page
    And I select that the representative is a solicitor
    And I select that the representative is an individual
    Then I am taken to the representative details (individual) page
    And I fill in the details and progress to the representative copy page
    And I select text message and fill in an email and a non matching phone number
    Then I am shown a blank phone error

  Scenario: Timeout test - should trigger
    When I wait for 11 minutes
    And I select yes
    Then I will see the invalid session timeout error