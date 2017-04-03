@javascript
Feature: Plot Residents
  As an admin
  I want to assign a resident to a plot
  So that the resident can log in to hoozzi and view their plot

  Scenario: Developer Admin
    Given I am a Development Admin wanting to assign a new resident to a plot
    When I assign a new resident to a plot
    Then I should see the created plot residency
    When I update the plot resident's email
    Then I should see an error
    When I update the plot residency
    Then I should see the updated plot residency
    When I delete a plot residency
    Then I should not see the plot residency
