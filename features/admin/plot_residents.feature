@javascript
Feature: Plot Residents
  As an admin
  I want to assign a resident to a plot
  So that the resident can log in and view their plot

  Scenario: Development Admin
    Given I am a Development Admin wanting to assign a new resident to a plot
    When I assign a new resident to a plot
    Then I should see the created plot residency
    When I update the plot residency
    Then I should see the updated plot residency
    When I create another plot resident
    Then I should see two residents for the plot
    When I view the phase
    Then I should see no activated residents
    When I view the plot
    Then I should see the resident is not activated
    When I delete a plot residency
    Then I should not see the plot residency
    And the resident should have been deleted

  Scenario: Multiple plots
    Given I am a Development Admin wanting to assign a new resident to a plot
    When I assign a new resident to a plot
    Then I should see the created plot residency
    Given The resident subscribes to emails
    When I view the phase
    Then I should see one activated resident
    When I view the plot
    Then I should see the activated resident
    And there is a plot in another phase
    When I assign the same resident to the second plot
    Then I should see the created plot residency
    When I delete the second plot residency
    Then the resident should still be associated to the first plot
    And the resident should still receive notifications

  Scenario: Add same email to same plot
    Given I am a Development Admin wanting to assign a new resident to a plot
    When I assign a new resident to a plot
    Then I should see the created plot residency
    When I assign a new resident to a plot
    Then I should see a duplicate resident notice

  Scenario: Add existing resident with no phone number (legacy)
    Given I am a Development Admin wanting to assign a new resident to a plot
    And There is a resident without phone number assigned to the plot
    When I delete the second plot residency
    And there is a plot
    And I assign the legacy resident to another plot
    Then I should see the created plot residency

  Scenario: Invalid create
    Given I am a Development Admin wanting to assign a new resident to a plot
    When I assign a new resident to the plot without completing the mandatory fields
    Then I should see the invalid resident errors
    When I assign a new resident to a plot
    Then I should see the created plot residency
