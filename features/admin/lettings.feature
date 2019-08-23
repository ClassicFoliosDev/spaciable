@javascript @poke
Feature: Lettings
  As a CF Admin
  I want to mark plots are letable

  Scenario: CF Admin sets up letable plots
    Given I am logged in as an admin
    And there is a developer
    And there is a division
    And there is a division development
    When I navigate to the division development
    When I create a phase for the division development
    Given there is a unit type for the development
    And there are two plots on the phase
    When I navigate to the lettings tab
    And I make one plot admin letable
    Then I can see the plot in the admin lettings list
    And when I make one plot homeowner letable
    Then I can see the plot in the homeowner lettings list
    And if I delete the plot from homeowner lettings
    Then the plot is no longer in the homeowner lettings list
    And if I swap the admin letting to homeowner lettings
    Then I can see the admin plot in the homeowner lettings list
    Given the plot has been let
    Then I can no longer make the plot unlettable
    And I can no longer swap the plot letter type
    Given the plot has not been let
    Then I can make it unlettable using the form

  Scenario: Client Admin sets up lettings account and plot letting
    Given I am logged in as a Development Admin
    And there is a phase plot
    And the plot is admin lettable
    And there is a second phase plot
    And the plot is homeowner lettable
    When I navigate to the phase
    Then I can visit the lettings tab
    And I can set up a managed lettings account
    Then I see a list of my lettable plots
    And I cannot see the homeowner lettable plots
    And I can set up my plot letting
    And I can see my plot marked as set up
    And I can see the links to my lettings account

