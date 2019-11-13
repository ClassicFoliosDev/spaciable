@javascript @poke
Feature: Analytics
  As a CF Admin
  I want to export analytics
  So I can use them to see how the site is used

  Scenario: Summary Report
    Given I am logged in as a cf admin
    And there is a developer with plots
    And there is another developer with plots
    When I navigate to the analytics page
    And I export the Summary Report
    Then the Summary Report contents are correct

  Scenario: Developer Report
    Given I am logged in as a cf admin
    And there is a developer with plots
    And there is another developer with plots
    When I navigate to the analytics page
    Then I cannot export a Developer Report
    When I select the developer
    Then I can export the Developer Report
    And the Developer Report contents are correct

  Scenario: Development Report
    Given I am logged in as a cf admin
    And there is a developer with plots
    And there is another developer with plots
    When I navigate to the analytics page
    Then I cannot export a Development Report
    When I select the development
    Then I can export the Development Report
    And the Development Report contents are correct
    And if I select Completion only plots
    Then I can export the Development Report
    And the Completion Development Report contents are correct