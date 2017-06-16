Feature: Developers
  As a CF Admin
  I want to add appliance_categories
  So that I can use them when I create a new appliance

  @javascript
  Scenario: Create appliance_category
    Given I am logged in as an admin
    And there is a manufacturer
    And there is an appliance
    When I create an appliance_category
    Then I should see the created appliance_category
    When I update the appliance_category
    Then I should see the updated appliance_category
    When I create an appliance with the new appliance_category
    Then I should see the appliance created successfully

  @javascript
  Scenario: Test using and deleting the appliance_category
    Given I am logged in as an admin
    And there is an appliance_category
    When I delete the appliance_category
    Then I should see the appliance_category delete complete successfully

  Scenario: Developer
    Given I am logged in as a Developer Admin
    Then I should not see appliance_categories

