@javascript @poke
Feature: Plots
  As a homeowner with multiple plots
  I want to be able to switch between plots
  So I can see each plot's details

  Scenario: Multiple plots
    Given I am logged in as a homeowner with multiple plots
    When I log in as homeowner
    Then I see all the plots I own
