Feature: Appliances
  As a CF Admin
  I want to add appliances
  So that I can add them to rooms and the home owner knows what they are getting

  @javascript
  Scenario: Dynamic dropdowns
    Given I am logged in as an admin
    And I have seeded the database
    And I create an appliance
    And I update the appliance
    When I update the dropdown
    Then I should see the updated appliance with selects

  @javascript
  Scenario: Delete
    Given I am logged in as an admin
    And I have created an appliance
    When I delete the appliance
    Then I should see the appliance deletion complete successfully
