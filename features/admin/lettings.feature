@javascript @poke
Feature: Lettings
  As a CF Admin
  I want to mark plots are letable

  Scenario: Lettings default
    Given I am logged in as an admin
    And there is a developer
    And there is a division
    And there is a division development
    When I navigate to the division development
    When I create a phase for the division development
    Then lettings is enabled by default
    Given there is a unit type for the development
    When I create a plot under the phase
    Then the plot is letable
    When I edit the phase to be unletable
    Then the phase is unletable
    Then the plot becomes unletable
    And I can update the plot to be letable
    And the plot is letable

  Scenario: Lettings default
    Given I am logged in as an admin
    And there is a developer
    And there is a division
    And there is a division development
    When I navigate to the division development
    When I create an unletable phase for the division development
    Then lettings is disabled
    Given there is a unit type for the development
    When I create a plot under the phase
    Then the plot is unletable
