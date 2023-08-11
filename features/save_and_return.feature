Feature: Save and return

  Scenario: User signed in, does not see save and return page (appeal journey)
    Given I am on the appeal case type page
    When I click continue
    Then I should see a 'Select what your appeal is about' error
    When I click on continue after selecting Income Tax option
    And I select english only
    Then I should be on the challenge decision page

  Scenario: User signed in, does not see save and return page (closure journey)
    Given I am on the closure case type page
    When I click continue
    Then I should see a 'Select the type of enquiry you want to close' error
    When I submit that it is a personal return
    Then I should be on the closure user type page

  Scenario: User not signed in, create an account (appeal journey)
    Given I am on the appeal case type page without login
    And I click on continue after selecting Income Tax option
    And I create an account in appeal journey
    When I click on continue when I am on the save confirmation page
    And I select english only
    Then I should be on the challenge decision page

  Scenario: User not signed in, create an account (closure journey)
    Given I am on the closure case type page without login
    And I submit that it is a personal return
    And I create an account in closure journey
    When I click on continue when I am on the save confirmation page
    And I select english only
    Then I should be on the closure user type page

  Scenario: Timeout test - should trigger (logged in user)
    Given I am on the appeal case type page
    When I click on continue after selecting Income Tax option
    And I wait for 11 minutes
    And I select english only
    Then I will see the invalid session timeout error

  Scenario: Timeout test - should trigger (not logged in user)
    Given I am on the closure case type page without login
    And I submit that it is a personal return
    And I create an account in closure journey
    And I wait for 11 minutes
    When I click on continue when I am on the save confirmation page
    Then I will see the invalid session timeout error
