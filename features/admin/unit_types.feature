Feature: UnitTypes
  As a CF Admin
  I want to add the development unit types
  So that I can categorise the homes to be built

  # Note that adding javascript here will mean that capybara can't find the select
  # box tested in When I update the unit type
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
