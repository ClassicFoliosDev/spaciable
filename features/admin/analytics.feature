@javascript
Feature: Analytics
  As a CF Admin
  I want to export analytics
  So I can use them to see how Hoozzi is used

  Scenario: Developer report
    Given I am CF Admin wanting to send notifications to residents
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
