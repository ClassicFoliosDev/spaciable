@javascript
Feature: Developments
  As a CF Admin
  I want to add our clients developments
  So that we can record the building work that the client is doing

  Scenario: Developers
    Given I am logged in as an admin
    And there is a developer
    When I create a development for the developer
    Then I should see the created developer development
    When I update the developers development
    Then I should see the updated developer development
    When I delete the developers development
    Then I should see that the deletion was successful for the developer development

  Scenario: Divisions
    Given I am logged in as an admin
    And there is a developer with a division
    When I create a development for the division
    Then I should see the created division development
    When I update the divisions development
    Then I should see the updated divisions development
    When I view the division development phases
    Then I should be able to return to the division development
    And I delete the divisions development
    Then I should see that the deletion was successful for the divisions development
