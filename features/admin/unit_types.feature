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

  Scenario: Division Admin
    Given I am a Division Admin
    And there is a division development
    When I navigate to the division development
    Then I should not be able to create a unit type

  Scenario: Development Admin
    Given I am a Development Admin
    When I navigate to the development
    Then I should not be able to create a unit type
