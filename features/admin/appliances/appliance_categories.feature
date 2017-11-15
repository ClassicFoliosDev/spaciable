Feature: Developers
  As a CF Admin
  I want to add appliance categories
  So that I can use them when I create a new appliance

  @javascript @slow
  Scenario: Create appliance category
    Given I am logged in as an admin
    And there is an appliance manufacturer
    And there is an appliance
    When I create an appliance category
    Then I should see the created appliance category
    When I update the appliance category
    Then I should see the updated appliance category

  @javascript @slow
  Scenario: Test deleting the appliance category
    Given I am logged in as an admin
    And there is an appliance category
    When I delete the appliance category
    Then I should see the appliance category delete complete successfully

  Scenario: Developer
    Given I am logged in as a Developer Admin
    Then I should not see appliance categories
