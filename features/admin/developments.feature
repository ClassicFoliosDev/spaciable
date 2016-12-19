@javascript
Feature: Developments
  As a CF Admin
  I want to add our clients develeopments
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
