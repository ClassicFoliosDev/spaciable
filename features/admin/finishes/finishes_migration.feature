@javascript @poke
Feature: Plot Rooms
  As an admin
  I want to create developer finishes on initialisation and release

  Scenario: Finish initialisation
    Given I am logged in as an admin
    And I have a developer with a development with unit types and plots with rooms and finishes
    And plot CreateFixture.phase_plot_name is completed
    And plot CreateFixture.phase_plot2_name is completed
    And CreateFixture.phase_plot_name has a CreateFixture.bedroom2_name room with a green finish
    And CreateFixture.phase_plot2_name has a CreateFixture.bedroom2_name room with a maize finish
    And CreateFixture.phase_plot2_name has a CreateFixture.lounge_name room with a sunflower finish
    And CreateFixture.phase_plot3_name has a CreateFixture.bedroom2_name room with a Morrocco finish
    And CreateFixture.phase_plot3_name has a CreateFixture.lounge_name room with a red finish
    And that I have developer, division and development users
    Then I should not see CAS visable and enabled at the development
    When I enable CAS for the developer
    Then I should see CAS visable and enabled at the development
    When I log out as admin
    And I log in as the primary developer admin
    Then I should see the standard list of finishes
    And I should see a developer copy of the Azure finish
    And I should see a developer copy of the Clown finish
    And I should see a developer copy of the green finish
    And I should see a developer copy of the maize finish
    And I should see a developer copy of the purple finish
    And I should see a developer copy of the red finish
    And I should see a developer copy of the sunflower finish
    And I should not see a developer copy of the blue finish
    And I should not see a developer copy of the bluebell finish
    And I should not see a developer copy of the Morrocco finish
    And plot CreateFixture.phase_plot_name rooms are using cf_admin finishes
    And plot CreateFixture.phase_plot2_name rooms are using developer finishes
    And plot CreateFixture.phase_plot3_name rooms are using cf_admin finishes
    When I log out as developer admin
    And I log in as cf_admin
    And plot CreateFixture.phase_plot3_name is completed
    When I log out as an admin
    And I log in as the primary developer admin
    And I should not see a developer copy of the blue finish
    And I should not see a developer copy of the bluebell finish
    And I should see a developer copy of the Morrocco finish
    And plot CreateFixture.phase_plot3_name rooms are using developer finishes
    When I log out as developer admin
    And I log in as cf_admin
    And CreateFixture.phase_plot_name has a CreateFixture.bedroom2_name room with a blue finish
    And I update the unit_type for plot CreateFixture.phase_plot_name to CreateFixture.second_unit_type_name
    When I log out as an admin
    Then I log in as the primary developer admin
    Then I should see a developer copy of the blue finish
    And I should not see a developer copy of the bluebell finish
    And plot CreateFixture.phase_plot_name rooms are using developer finishes

