@javascript @poke
Feature: Plot Rooms
  As an admin
  I want to configure individual rooms
  So that I do not have to stick to rooms associated with a unit type

  @javascript
  Scenario: Admins
    Given I am logged in as a CF Admin wanting to manage plot rooms
    When I go to review the plot rooms
    Then I should see the plots unit type rooms
    When I add a new plot room
    Then I should see the new plot room
    And I should see no logs for CreateFixture.phase_plot
    When I update one of the default unit type rooms
    Then I should see the updated plot room
    Given there is a finish
    When I add a finish to one of the default unit type rooms
    Then I should see the new plot room with the finish
    Given there is an appliance manufacturer
    And there is an appliance
    When I add an appliance to one of the default unit type rooms
    Then I should see the new plot room with the appliance
    When I delete one of the default unit type rooms
    Then I should not see the deleted default unit type room
    When I review the plots unit type rooms
    Then I should see the unchanged unit type rooms

  Scenario Outline: CAS Admins
    Given I am logged in as a CAS <role> wanting to manage plot rooms
    And all the plots are release completed
    When I go to review the plot rooms
    Then I should see the plots unit type rooms
    When I add a new plot room
    Then I should see the new plot room
    And I should see a PlotRoomsFixture.new_plot_room_name created plot log entry for CreateFixture.phase_plot created by $current_user.full_name
    When I update one of the default unit type rooms
    Then I should see the updated plot room
    And I should see a PlotRoomsFixture.updated_plot_room_name created plot log entry for CreateFixture.phase_plot created by $current_user.full_name
    Given there is a finish for developer CreateFixture.developer
    When I add a finish to one of the default unit type rooms
    Then I should see the new plot room with the finish
    And I should see a PlotRoomsFixture.template_room_to_add_finish created plot log entry for CreateFixture.phase_plot created by $current_user.full_name
    And I should see a PlotRoomsFixture.template_room_to_add_finish deleted plot log entry for CreateFixture.phase_plot created by $current_user.full_name
    And I should see a "Finish Fluffy carpet" added plot log entry for CreateFixture.phase_plot created by $current_user.full_name
    Given there is an appliance manufacturer
    And there is an appliance
    When I add an appliance to one of the default unit type rooms
    Then I should see the new plot room with the appliance
    And I should see a CreateFixture.full_appliance_name added plot log entry for CreateFixture.phase_plot created by $current_user.full_name
    When I delete one of the default unit type rooms
    Then I should not see the deleted default unit type room
    And I should see a PlotRoomsFixture.template_room_to_delete deleted plot log entry for CreateFixture.phase_plot created by $current_user.full_name
    When I review the plots unit type rooms
    Then I should see the unchanged unit type rooms
    Examples:
      | role               |
      | Developer Admin    |
      | Development Admin  |
      | Site Admin         |

  Scenario: Remove
    Given I am logged in as a CF Admin wanting to manage plot rooms
    And the unit type has an appliance and a finish
    When I go to review the plot rooms
    And I remove a finish from the plot
    Then I should see the finish remove is successful
    When I remove an appliance from the plot
    Then I should see the appliance remove is successful
    And I should see the unit type still has appliance and finish

  Scenario Outline: CAS Remove
    Given I am logged in as a CAS <role> wanting to manage plot rooms
    And the unit type has an appliance and a finish
    When I go to review the plot rooms
    Then I cannot edit or delete the appliance or finish
    Given all the plots are release completed
    When I go to review the plot rooms
    And I remove a finish from the plot
    Then I should see the finish remove is successful
    When I remove an appliance from the plot
    Then I should see the appliance remove is successful
    And I should see the unit type still has appliance and finish
    Examples:
      | role               |
      | Developer Admin    |
      | Development Admin  |
      | Site Admin         |
