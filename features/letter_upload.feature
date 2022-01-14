
Feature: Letter upload type page (review conclusion letter)

  Background: Navigate to the letter upload type page
    Given I navigate to the letter upload type page

  Scenario: I press upload as one document and upload
    When I press one document option
    Then I am on the letter upload page
    When I select 'File upload requirements'
    Then I will see the file requirements
    When I successfully upload a document
    Then I am on the check answers page

  Scenario: Error Message
    When I press one document option
    Then I am on the letter upload page
    When I press continue with no file uploaded
    Then I see the no upload error

  Scenario: I press upload as multiple pages
    When I press upload as multiple pages option
    Then I am on the documents upload page

  Scenario: I press I do not have a letter
    When I press I do not have a letter
    Then I am on the letter upload type page and I see the validity message
    When I click the continue button
    Then I am taken to the home or save appeal page

  Scenario: Cannot upload a document
    When I press one document option
    Then I am on the letter upload page
    When I select I am having trouble uploading my document
    Then I am on the complete appeal by post page
