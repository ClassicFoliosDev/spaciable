@javascript @slow
Feature: Documents
  As an Admin
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
    And there is a developer with a development
    And there is a unit type
    When I upload a document for the unit type
    Then I should see the created document
    And I should see the original filename
    When I update the document
    Then I should see the updated unit_type document
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

  Scenario: Developer admin
    Given I am logged in as a Developer Admin
    When I upload a document for the developer
    Then I should see the created document
    And I should see the original filename
    When I update the developer's document
    Then I should see the updated developer document
    When I create another document
    Then I should see the document in the developer document list
    When I delete the document
    Then I should see that the deletion was successful for the developer document

  Scenario: Plot documents developer admin
    Given I am logged in as a Developer Admin
    And there is a phase plot
    When I upload a document for the phase plot
    Then I should see the created document
    And I should see the original filename
    When I update the document
    Then I should see the updated document for the phase plot
    When I delete the document
    Then I should see that the deletion was successful for the document
    When I navigate to the phase
    Then I should not see the bulk uploads tab

  Scenario: Plot documents division admin
    Given I am logged in as a Division Admin
    And there is a division phase plot
    When I upload a document for the division phase plot
    Then I should see the created document
    And I should see the original filename
    When I update the document
    Then I should see the updated document for the phase plot
    When I delete the document
    Then I should see that the deletion was successful for the document
    When I navigate to the division phase
    Then I should not see the bulk uploads tab

  Scenario: Plot documents development admin
    Given I am logged in as a Development Admin
    And there is a phase plot
    When I upload a document for the phase plot
    Then I should see the created document
    And I should see the original filename
    And I should see who uploaded the file
    When I update the document
    Then I should see the updated document for the phase plot
    When I delete the document
    Then I should see that the deletion was successful for the document
    When I navigate to the phase
    Then I should not see the bulk uploads tab

  Scenario: Plot image development admin image
    Given I am logged in as a Development Admin
    And there is a phase plot
    When I upload an image for the phase plot
    Then I should see the created image
    When I update the image name
    Then I should see the updated document for the phase plot
    When I delete the document
    Then I should see that the deletion was successful for the document

  Scenario: Plot svg image division admin
    Given I am logged in as a Division Admin
    And there is a division phase plot
    When I upload an svg image for the division phase plot
    Then I should see the created svg image
    When I update the image name
    Then I should see the updated document for the phase plot
    When I delete the document
    Then I should see that the deletion was successful for the document

  Scenario: Tenant notifications for private documents
    Given I am logged in as a Development Admin
    And there is a phase plot with a resident
    And there is a tenant
    When I upload a document for the development
    Then I should see the created document
    And I should see the original filename
    When I update the document
    Then only the homeowner should receive a notification

  Scenario: Tenant notifications for public documents
    Given I am logged in as a Developer Admin
    And there is a phase plot with a resident
    And there is a tenant
    When I upload a document for the developer
    Then I should see the created document
    And I should see the original filename
    When I update the document
    Then both homeowner and tenant should receive a notification

  Scenario: Multiple file uploads
    Given I am logged in as a Development Admin
    And there is a phase plot with a resident
    When I upload documents for the development
    Then I should see the documents have been created
    When I delete one of the documents
    Then I should see that the document has been deleted
