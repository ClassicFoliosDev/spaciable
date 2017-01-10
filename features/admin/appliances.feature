Feature: Appliances
  As a CF Admin
  I want to add appliances
  So that I can add them to rooms and the home owner knows what they are getting

  # Note that adding javascript here will mean that capybara can't find the select
  # box tested in When I update the unit type
  Scenario:
    Given I am logged in as an admin
    When I create an appliance
    Then I should see the created appliance
    When I update the appliance
    Then I should see the updated appliance

  @javascript
  Scenario: Dynamic dropdowns
    Given I am logged in as an admin
    And I have created an appliance
    And I have seeded the database
    When I update the dropdown
    Then I should see the updated appliance with selects

  @javascript
  Scenario: Delete
    Given I am logged in as an admin
    And I have created an appliance
    When I delete the appliance
    Then I should see the appliance deletion complete successfully
