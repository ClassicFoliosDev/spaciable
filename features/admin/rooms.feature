Feature: Rooms
  As a CF Admin
  I want to add rooms to a unit type
  So that I can provide details about the homes being built

  Scenario:
    Given I am logged in as an admin
    And I have seeded the database
    And there is a unit type
    When I create a room with no room name
    Then I should see the room failure message
    When I create a room
    Then I should see the created room
    When I update the room
    Then I should see the updated room

  @javascript
  Scenario: Finishes
  Given I am logged in as an admin
    And I have seeded the database
    And I have created a room
    And I have created a finish
    When I add a finish
    Then I should see the room with a finish
    When I add a finish
    Then I should see a duplicate finish error
    When I remove a finish
    Then I should see the room with no finish

  @javascript
  Scenario: Appliances
    Given I am logged in as an admin
    And I have seeded the database
    And I have created a room
    And I have created an appliance
    When I add an appliance
    Then I should see the room with an appliance
    When I add an appliance
    Then I should see a duplicate error
    When I remove an appliance
    Then I should see the room with no appliance

  @javascript
  Scenario: Delete
    Given I am logged in as an admin
    And I have created a room
    When I delete the room
    Then I should see the room deletion complete successfully
