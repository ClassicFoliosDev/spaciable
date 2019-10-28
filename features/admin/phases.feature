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

  Scenario: CFAdmin phase plot letting
    Given I am logged in as an admin
    And there are phase plots
    When I visit the phase
    When I navigate to the lettings tab
    Then I can add "admin" lettings
    And I can add "homeowner" lettings
    And I can move a "admin" letting to a "homeowner" letting
    And I can move a "homeowner" letting to a "admin" letting
    And I can delete a "homeowner" letting
    And I can delete a "admin" letting
    When a letting is live
    And I visit the phase
    And I navigate to the lettings tab
    Then I cannot move or delete the letting

  Scenario: Branch admin Phase plot letting
    Given I am logged in as a Developer Development branch Admin
    And there are admin lettable phase plots
    When I visit the phase
    Then I can see the lettings tab
    When I select the lettings tab
    Then I see instructions to authorise my account
    When I deny authorisation
    Then I am informed that Authorisation has been denied
    When I authorise from an incorrect planet rent account
    Then I am informed that the authorisation is incorrect
    When I authorise from the correct planet rent account
    Then I should see the admin lettable plots
    When I click to let an admin plot
    Then I should see an autofilled listings form
    Then I should be able complete the listing 
    And I should be able to list the plot on Planet Rent

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
    And I should not see the lettings tab

  Scenario: Spanish Phase
    Given I am logged in as an admin
    And I have a spanish developer with a development
    And I have configured the spanish development address
    When I create a phase for the spanish development
    Then I should see a spanish format phase address
    Then I should see a spanish developer address pre-filled

