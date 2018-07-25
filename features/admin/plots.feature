Feature: Plots
  As a CF Admin
  I want to add plots to a phase
  So that I can record the homes as they are built and sold

  @javascript
  Scenario: Phase Plots
    Given I am logged in as an admin
    And I have a developer with a development with unit types and a phase
    And I have configured the phase address
    When I create a plot for the phase
    Then I should see the created phase plot
    When I update the phase plot
    Then I should see the updated phase plot
    And I should see the phase address has not been changed
    When I update the release dates
    Then I should see the expiry date has been updated
    When I delete the phase plot
    Then I should see that the phase plot deletion completed successfully
    Given I have created a plot for the phase
    When I delete the phase plot
    Then I should see the phase address has not been changed
    When I send a notification the phase
    Then I should see the notification is not sent to the former resident

  @javascript
  Scenario: Plot preview
    Given I am logged in as an admin
    And I have a developer with a development with unit types and a phase
    And I have configured the phase address
    When I create a plot for the phase
    And I preview the plot
    Then I see the plot preview page
    And I can see my library
    And I can see my faqs
    And I can see my appliances
    And I can see my contacts

  @javascript
  Scenario: Developer Admin
    Given I am logged in as a Developer Admin
    And there is a phase plot resident
    And there is a second resident
    Then I can not create a plot
    And I can not edit a plot
    And I can update the completion date for a plot
    And the completion date has been set
    When I update the progress for the plot
    Then I should see the plot progress has been updated
    And both residents have been notified
    When I update the completion date for the plot
    Then both residents have been notified of the completion date

  @javascript
  Scenario: Development Admin
    Given I am logged in as a Development Admin
    And there is a phase plot resident
    And there is a second resident
    Then I can not create a plot
    And I can not edit a plot
    And I can update the completion date for a plot
    And the completion date has been set
    When I update the progress for the plot
    Then I should see the plot progress has been updated
    And both residents have been notified
    When I update the completion date for the plot
    Then both residents have been notified of the completion date

  Scenario: Site Admin
    Given I am logged in as a Site Admin
    And there is a phase plot resident
    Then I can not create a plot
    And I can not edit a plot
    And I can not update the progress for a plot
    And I can not update the completion date for a plot
