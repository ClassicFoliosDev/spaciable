@javascript
Feature: Plot Residents
  As an admin
  I want to assign a resident to a plot
  So that the resident can log in to hoozzi and view their plot

  Scenario: Development Admin
    Given I am a Development Admin wanting to assign a new resident to a plot
    When I assign a new resident to a plot
    Then I should see the created plot residency
    When I update the plot residency
    Then I should see the updated plot residency
    When I create another plot resident
    Then I should see two residents for the plot
    When I delete a plot residency
    Then I should not see the plot residency
    And the resident should no longer receive notifications

  Scenario: Multiple plots
    Given I am a Development Admin wanting to assign a new resident to a plot
    When I assign a new resident to a plot
    Then I should see the created plot residency
    Given The resident subscribes to emails
    And there is a plot in another phase
    When I assign the same resident to the second plot
    Then I should see the created plot residency
    When I delete the second plot residency
    Then the resident should still be associated to the first plot
    And the resident should still receive notifications
