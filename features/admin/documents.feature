@javascript
Feature: Documents
  As a CF Admin
  I want to add our clients documents
  So that we can provide information to home owners about their plot

  Scenario: Documents
    Given I am logged in as an admin
    And there is a developer
    When I upload a document for the developer
    Then I should see the created document
    And I should see the original filename
    When I update the developer's document
    Then I should see the updated document
    When I create another document
    Then I should see the document in the developer document list
    When I delete the document
    Then I should see that the deletion was successful for the document
