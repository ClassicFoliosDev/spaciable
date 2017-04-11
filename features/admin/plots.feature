Feature: Plots
  As a CF Admin
  I want to add the development plots
  So that the I can record the home built by the client

  @javascript
  Scenario:
    Given I am logged in as an admin
    And I have a developer with a development with unit types
    And I have configured the development address
    When I create a plot for the development
    Then I should see the created plot
    When I update the plot
    Then I should see the updated plot
    And I should see the development address has not been changed
    When I delete the plot
    Then I should see that the plot deletion completed successfully
    Given I have created a plot for the development
    When I delete the plot
    Then I should see the development address has not been changed

  @javascript
  Scenario: Plot preview
    Given I am logged in as an admin
    And I have a developer with a development with unit types
    And I have configured the development address
    When I create a plot for the development
    And I preview the plot
    Then I see the plot preview page
    And I can see my library
    And I can see my faqs
    And I can see my appliances
    And I can see my contacts

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
    When I delete the phase plot
    Then I should see that the phase plot deletion completed successfully
    Given I have created a plot for the phase
    When I delete the phase plot
    Then I should see the phase address has not been changed
