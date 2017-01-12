Feature: Plots
  As a CF Admin
  I want to add the development plots
  So that the I can record the home built by the client

  @javascript
  Scenario:
    Given I am logged in as an admin
    And I have a developer with a development with unit types
    When I create a plot for the development
    Then I should see the created plot
    When I update the plot
    Then I should see the updated plot
    When I delete the plot
    Then I should see that the plot deletion completed successfully

  @javascript
  Scenario: Phase Plots
    Given I am logged in as an admin
    And I have a developer with a development with unit types and a phase
    When I create a plot for the phase
    Then I should see the created phase plot
    When I update the phase plot
    Then I should see the updated phase plot
    When I delete the phase plot
    Then I should see that the phase plot deletion completed successfully
