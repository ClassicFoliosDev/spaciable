Feature: Rooms
  As a CF Admin
  I want to add rooms to a unit type
  So that I can provide details about the homes being built

  Scenario:
    Given I am logged in as an admin
    And I have seeded the database
    And I have a developer with a development and a unit type
    When I create a room for the development
    Then I should see the created room
    When I update the room and finish
    Then I should see the updated room

  @javascript
  Scenario: Finishes
  Given I am logged in as an admin
    And I have seeded the database
    And I have created a room
    When I add a second finish
    Then I should see the room with two finishes

  @javascript
  Scenario: Delete
    Given I am logged in as an admin
    And I have created a room
    When I delete the room
    Then I should see the room deletion complete successfully
