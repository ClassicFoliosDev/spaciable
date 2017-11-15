Feature: Developers
  As a CF Admin
  I want to add manufacturers
  So that I can use them when I create a new appliance

  @javascript @slow
  Scenario: Create manufacturer
    Given I am logged in as an admin
    And there is an appliance category
    When I create an appliance manufacturer
    Then I should see the created appliance manufacturer
    When I create an appliance with the new appliance manufacturer
    Then I should see the appliance with manufacturer created successfully
    When I update the appliance manufacturer
    Then I should see the updated appliance manufacturer
    And I should see the appliance that uses it has been updated

  @javascript @slow
  Scenario: Test deleting the appliance_manufacturer
    Given I am logged in as an admin
    And there is an appliance manufacturer
    When I delete the appliance manufacturer
    Then I should see the appliance manufacturer delete complete successfully

  Scenario: Developer
    Given I am logged in as a Developer Admin
    Then I should not see appliance manufacturers
