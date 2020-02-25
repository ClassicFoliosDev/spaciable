@slow
Feature: UnitTypes
  As a CF Admin
  I want to add the development unit types
  So that I can categorise the homes to be built

  Scenario:
    Given I am logged in as an admin
    And I have a developer with a development
    When I create a unit type for the development
    Then I should see the created unit type
    When I update the unit type
    Then I should see the updated unit type

  Scenario: Clone empty unit type
    Given I am logged in as an admin
    And there is a division plot
    When I navigate to the division development
    When I clone the unit type
    Then I should see a duplicate unit type created successfully
    And I clone the unit type
    Then I should see another duplicate unit type created successfully
    When I clone a unit type twice
    Then I should see another duplicate unit type created successfully

  @javascript
  Scenario: Clone full unit type
    Given I am logged in as an admin
    And there is a unit type room with finish and appliance
    And I upload a document for the unit type
    When I navigate to the development
    And I clone the unit type
    Then I should see a duplicate unit type with finish and appliance created successfully
    And the document has not been cloned
    When I delete the appliance
    And I delete the finish
    When I navigate to the development
    And I clone the unit type
    Then I should see a duplicate unit type without finish and appliance created successfully

  @javascript
  Scenario: Delete
    Given I am logged in as an admin
    And I have created a unit type
    When I delete the unit type
    Then I should see the deletion complete successfully

  Scenario: Developer Admin
    Given I am a Developer Admin
    And there is a development
    When I navigate to the development
    Then I should not be able to create a unit type
    When there is a unit type
    Then I should not be able to clone a unit type

  Scenario: Division Admin
    Given I am a Division Admin
    And there is a division development
    When I navigate to the division development
    Then I should not be able to create a unit type
    When there is a division development unit type
    Then I should not be able to clone a unit type

  Scenario: Development Admin
    Given I am a Development Admin
    When I navigate to the development
    Then I should not be able to create a unit type
    When there is a unit type
    Then I should not be able to clone a unit type

  @javascript
  Scenario: Delete unit type for plots
    Given I am logged in as an admin
    And I have a developer with a development with unit types and a phase
    And I have configured the phase address
    When I create a plot for the phase
    Then I should see the created phase plot
    When I delete the unit type associated with a plot
    Then I should see dialog warning of the associated phase and plot


