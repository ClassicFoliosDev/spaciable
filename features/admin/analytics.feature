@javascript
Feature: Analytics
  As a CF Admin
  I want to export analytics
  So I can use them to see how the site is used

  Scenario: All developers and billing reports
    Given I am CF Admin wanting to send notifications to residents
    And there is another developer with a division and development
    And there is another developer with no children
    When I navigate to the analytics page
    And I export all developers CSV
    Then the all developer CSV contents are correct
    And I export billing CSV
    Then the all billing CSV contents are correct

  Scenario: Developer report
    Given I am CF Admin wanting to send notifications to residents
    And there is another development for the division
    When I navigate to the analytics page
    Then I can not export a developer CSV
    When I select the developer
    And I export a developer CSV
    Then the developer CSV contents are correct

  Scenario: Development report
    Given I am CF Admin wanting to send notifications to residents
    When I navigate to the analytics page
    And I select the developer
    Then I can not export a development CSV
    And I select the development
    And I export a development CSV
    Then the development CSV contents are correct
