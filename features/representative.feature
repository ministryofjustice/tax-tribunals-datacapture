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
    When I press yes and enter a invalid then valid email
    Then I see the grounds for appeal page

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


