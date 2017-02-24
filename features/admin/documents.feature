@javascript
Feature: Documents
  As a CF Admin
  I want to add our clients documents
  So that we can provide information to home owners about their plot

  Scenario: Developer
    Given I am logged in as an admin
    And there is a developer
    When I upload a document for the developer
    Then I should see the created document
    And I should see the original filename
    When I update the developer's document
    Then I should see the updated developer document
    When I create another document
    Then I should see the document in the developer document list
    When I delete the document
    Then I should see that the deletion was successful for the developer document

  Scenario: Division
    Given I am logged in as an admin
    And there is a developer with a division
    When I upload a document for the division
    Then I should see the created document
    And I should see the original filename
    When I update the document
    Then I should see the updated division document
    When I delete the document
    Then I should see that the deletion was successful for the document

  Scenario: Developer development
    Given I am logged in as an admin
    And there is a developer with a development
    When I upload a document for the development
    Then I should see the created document
    And I should see the original filename
    When I update the document
    Then I should see the updated development document
    When I delete the document
    Then I should see that the deletion was successful for the document

  Scenario: Division development
    Given I am logged in as an admin
    And there is a division with a development
    When I upload a document for the division development
    Then I should see the created document
    And I should see the original filename
    When I update the document
    Then I should see the updated division_development document
    When I delete the document
    Then I should see that the deletion was successful for the document

  Scenario: Phase
    Given I am logged in as an admin
    And there is a phase
    When I upload a document for the phase
    Then I should see the created document
    And I should see the original filename
    When I update the document
    Then I should see the updated phase document
    When I delete the document
    Then I should see that the deletion was successful for the document

  Scenario: Division phase
    Given I am logged in as an admin
    And there is a division phase
    When I upload a document for the division phase
    Then I should see the created document
    And I should see the original filename
    When I update the document
    Then I should see the updated division_phase document
    When I delete the document
    Then I should see that the deletion was successful for the document

  Scenario: Unit type
    Given I am logged in as an admin
    And there is a unit type
    When I upload a document for the unit type
    Then I should see the created document
    And I should see the original filename
    When I update the document
    Then I should see the updated unit_type document
    When I delete the document
    Then I should see that the deletion was successful for the document

  Scenario: Plot
    Given I am logged in as an admin
    And there is a plot
    When I upload a document for the plot
    Then I should see the created document
    And I should see the original filename
    When I update the document
    Then I should see the updated document for the plot
    When I delete the document
    Then I should see that the deletion was successful for the document

  Scenario: Phase plot
    Given I am logged in as an admin
    And there is a phase plot
    When I upload a document for the phase plot
    Then I should see the created document
    And I should see the original filename
    When I update the document
    Then I should see the updated document for the phase plot
    When I delete the document
    Then I should see that the deletion was successful for the document

