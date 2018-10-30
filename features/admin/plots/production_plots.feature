Feature: Production Plots
  As a CF Admin
  I want to see a production view of plots
  So that I can review all the homes for a phase are configured correctly

  Scenario: Production plots
    Given I am logged in as an admin
    And there is a phase plot with a resident
    And there is another plot with completion and reservation release dates
    When I visit the production tab
    Then I should see the list of plots with address and release date fields

# Non-cf-admin tests are in phases.feature
