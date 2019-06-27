@javascript @poke
Feature: Phases
  As a CF Admin
  I want to add the development phases
  So that the I can match the development approach of the client

  Scenario:
    Given I am logged in as an admin
    And I have a developer with a development
    And I have configured the development address
    When I create a phase for the development
    Then I should see the created phase
    When I update the phase
    Then I should see the updated phase
    And I should see the development address has not been changed
    When I delete the phase
    Then I should see that the deletion completed successfully
    Given I create a phase for the development
    When I delete the phase
    Then I should see the development address has not been changed

  Scenario: Phase plot progress
    Given I am logged in as an admin
    And there is a phase plot with a resident
    When I update the progress for the phase
    Then I should see the phase progress has been updated
    And Phase residents should have been notified

  Scenario: Phase plot progress for deleted plot
    Given I am logged in as an admin
    And there is a phase plot with a resident
    And I delete the plot with resident
    When I update the progress for the phase
    Then I should see the phase progress has been updated
    And I should see the progress update is not sent to the former resident

  Scenario: Site Admin
    Given I am logged in as a Site Admin
    And there is a phase plot with a resident
    When I visit the phase
    Then I can not update the progress for a plot
    And I should not see the production tab

  Scenario: Development admin
    Given I am logged in as a Development Admin
    And there is a phase plot with a resident
    When I update the progress for the phase
    Then I should see the phase progress has been updated
    And I should not see the production tab

  Scenario: Spanish Phase
    Given I am logged in as an admin
    And I have a spanish developer with a development
    And I have configured the spanish development address
    When I create a phase for the spanish development
    Then I should see a spanish format phase address
    Then I should see a spanish developer address pre-filled
