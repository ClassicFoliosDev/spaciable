@javascript @slow
Feature: Plots
  As a CF Admin
  I want to add plots to a phase
  So that I can record the homes as they are built and sold

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
    When I update the order numbers
    Then I should see the order numbers have been updated
    When I delete the phase plot
    Then I should see that the phase plot deletion completed successfully
    Given I have created a plot for the phase
    When I delete the phase plot
    Then I should see the phase address has not been changed
    When I send a notification the phase
    Then I should see the notification is not sent to the former resident

  Scenario Outline: CAS Phase Plots
    Given I am logged in as a <role> with CAS
    And I have a CAS developer with a development with unit types and a phase
    And I have a phase plot
    And all the plots are release completed
    When I CAS update the phase plot
    Then I should see the CAS updated phase plot
    And I cannot delete the phase plot
    Examples:
      | role               |
      | Developer Admin    |
      | Development Admin  |

  Scenario Outline: CAS Phase restricted Plots
    Given I am logged in as a <role> with CAS
    And I have a CAS developer with a development with unit types and a phase
    And I have a phase plot
    And the unit types are restricted
    When I CAS update the phase restricted plot
    Then I should see the CAS updated restricted phase plot
    And I cannot delete the phase plot
    And I cannot update or delete or add to the restricted phase plot rooms
    And I cannot update or delete or add to the restricted phase plot finishes and appliances
    Examples:
      | role               |
      | Developer Admin    |
      | Development Admin  |

  Scenario: Phase Plot Ranges
    Given I am logged in as an admin
    And I have a developer with a development with unit types and a phase
    And I have configured the phase address
    When I specify "invalid" range of plots
    Then I see an invalid range message
    When I specify "valid" range of plots
    Then I see a range of new plots

  Scenario: Address Prefix
    Given I am logged in as an admin
    And I have a developer with a development with unit types and a phase
    When I create a plot with prefix and copy plot numbers
    Then I should see the postal number inherit from the plot number
    When I edit a plot with prefix and postal number
    Then the postal number should not inherit from the plot number

  Scenario: Plot preview
    Given I am logged in as an admin
    And I have a developer with a development with unit types and a phase
    And I have configured the phase address
    When I create a plot for the phase
    And there are documents
    And I preview the plot
    Then I see the plot preview page
    And I can see my library
    And I can see my faqs
    And I can see my appliances
    And I can see my contacts

  Scenario Outline: Developer/Development Admin
    Given I am logged in as a <role>
    And there is a phase plot resident
    And there is a second resident
    And all the plots are release completed
    Then I can not create a plot
    And I can not edit a plot
    And I can update the completion date for a plot
    And the completion date has been set
    When I update the progress for the plot
    Then I should see the plot progress has been updated
    And both residents have been notified
    Examples:
      | role               |
      | Developer Admin    |
      | Development Admin  |

  Scenario: Site Admin
    Given I am logged in as a Site Admin
    And there is a phase plot resident
    Then I can not create a plot
    And I can not edit a plot
    And I can not update the progress for a plot
    And I can not update the completion date for a plot

  Scenario: Copy plot numbers
    Given I am logged in as an admin
    And I have a developer with a development with unit types and a phase
    And I have configured the phase address
    When I create plots for the phase
    Then I should see the plots have been created
    And the plots should have the postal number configured

  Scenario: Phase Plots
    Given I am logged in as an admin
    And I have a spanish developer with a development with unit types and a phase
    When I create a plot for the spanish phase
    Then I should see the spanish plot address format

