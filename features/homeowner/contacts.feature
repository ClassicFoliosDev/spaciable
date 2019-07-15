@javascript @poke
Feature: Homeowner Contacts
  As a homeowner
  When I log in
  I want to see the contact details for my developer

  Scenario:
    Given I have a developer with a development with unit type and plot
    And there are division contacts
    And I have logged in as a resident and associated the division development plot
    When I visit the contacts page
    Then I should see the contacts for my plot
    And I should see contacts on the dashboard
