@javascript
Feature: Documents
  As a CF Admin
  I want to edit plots in bulk
  So that I can update a range of plots more quickly

  Scenario: CF Admin
    Given I am a CF admin and there are many plots
    When I bulk edit the plots
    Then there is an error for plots that don't exist
    And the selected plots are updated
    And the unselected plots are not updated
    When I set the postal number for plots
    Then the selected plots have the new postal number

  Scenario: Unset and not set
    Given I am a CF admin and there is a plot with all fields set
    When I bulk edit the plot but do not set checkboxes
    Then the plot fields are all unchanged
    When I bulk edit the plot and set optional fields to empty
    Then the optional plot fields are unset
    When I bulk edit the plot and set mandatory fields to empty
    Then I see an error for the mandatory fields

  Scenario: Developer Admin
    Given I am logged in as a Developer Admin
    And there is a phase plot with a resident
    Then I can not edit bulk plots

  Scenario: Division Admin
    Given I am logged in as a Division Admin
    And there is a division phase plot
    Then I can not edit bulk plots

  Scenario: Development Admin
    Given I am logged in as a Development Admin
    And there is a phase plot with a resident
    Then I can not edit bulk plots

  Scenario: Site Admin
    Given I am logged in as a Site Admin
    And there is a phase plot with a resident
    Then I can not edit bulk plots

  Scenario: CF Admin
    Given I am a CF admin and there are many spanish plots
    When I bulk edit the spanish plots
    Then I should see spanish address options
