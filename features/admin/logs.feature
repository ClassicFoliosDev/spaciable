@slow
Feature: Logs
  As an Admin
  I want to see logs for unit type and plot operations
  So that I can monitor and analyse

  Scenario:
    Given I am logged in as an admin
    And I have a developer with a development
    When I create a unit type for the development
    Then I should see the created unit type
    And I should see no unit type logs

  @javascript
  Scenario:
    Given I am logged in as an admin
    And there is a finish
    And there is an appliance
    And I have a developer with a CAS development
    And that I have developer, division and development users
    And there is a finish for developer CreateFixture.developer
    When I create a unit type for the development
    Then I should see the created unit type
    And I should see unit type logs
    And I should see a CreateFixture.unit_type_name created log entry created by $current_user.full_name
    When I add a room to the unit type
    Then I should see a CreateFixture.room_name created log entry created by $current_user.full_name
    When I edit a room for the unit type
    Then I should see a CreateFixture.kitchen_name updated log entry created by $current_user.full_name
    When I add a finish to the unit type room
    Then I should see a CreateFixture.finish_name added log entry created by $current_user.full_name
    When I delete a finish from the unit type room
    Then I should see a CreateFixture.finish_name removed log entry created by $current_user.full_name
    When I add an appliance to the unit type room
    Then I should see a CreateFixture.appliance_name added log entry created by $current_user.full_name
    When I delete an appliance from the unit type room
    Then I should see a CreateFixture.appliance_name removed log entry created by $current_user.full_name
    When I delete a unit type room
    Then I should see a CreateFixture.kitchen_name deleted log entry created by $current_user.full_name
    When I log out as an admin
    And I log in as the primary developer admin
    Then I should see unit type logs
    And I should see a CreateFixture.unit_type_name created log entry created by "CF Admin"
    And I should see a CreateFixture.room_name created log entry created by "CF Admin"
    And I should see a CreateFixture.kitchen_name updated log entry created by "CF Admin"
    And I should see a CreateFixture.finish_name added log entry created by "CF Admin"
    And I should see a CreateFixture.finish_name removed log entry created by "CF Admin"
    And I should see a CreateFixture.appliance_name added log entry created by "CF Admin"
    And I should see a CreateFixture.finish_name removed log entry created by "CF Admin"
    And I should see a CreateFixture.kitchen_name deleted log entry created by "CF Admin"
    When I add a room to the unit type
    Then I should see a CreateFixture.room_name created log entry created by $current_user.full_name
    When I edit a room for the unit type
    Then I should see a CreateFixture.kitchen_name updated log entry created by $current_user.full_name
    When I add a finish to the unit type room
    Then I should see a CreateFixture.finish_name added log entry created by $current_user.full_name
    When I delete a finish from the unit type room
    Then I should see a CreateFixture.finish_name removed log entry created by $current_user.full_name
    When I add an appliance to the unit type room
    Then I should see a CreateFixture.appliance_name added log entry created by $current_user.full_name
    When I delete an appliance from the unit type room
    Then I should see a CreateFixture.finish_name removed log entry created by $current_user.full_name
    When I delete a unit type room
    Then I should see a CreateFixture.kitchen_name deleted log entry created by $current_user.full_name
    Then I log out as a an admin
    And I log in as CF Admin
    And I should see a CreateFixture.room_name created log entry created by LettingsFixture.developer_admins.first.full_name
    And I should see a CreateFixture.kitchen_name updated log entry created by LettingsFixture.developer_admins.first.full_name
    And I should see a CreateFixture.finish_name added log entry created by LettingsFixture.developer_admins.first.full_name
    And I should see a CreateFixture.finish_name removed log entry created by LettingsFixture.developer_admins.first.full_name
    And I should see a CreateFixture.appliance_name added log entry created by LettingsFixture.developer_admins.first.full_name
    And I should see a CreateFixture.finish_name removed log entry created by LettingsFixture.developer_admins.first.full_name
    And I should see a CreateFixture.kitchen_name deleted log entry created by LettingsFixture.developer_admins.first.full_name


