Feature: Appliances
  As a CF Admin
  I want to add appliances
  So that I can add them to rooms and the home owner knows what they are getting

  @javascript
  Scenario:
    Given I am logged in as an admin
    And I have seeded the database with appliances
    When I create an appliance with no name
    Then I should see the appliance model num error
    When I create an appliance with no category
    Then I should see the appliance category error
    When I create an appliance
    Then I should see the created appliance
    When I delete the appliance manufacturer
    Then I should see a failed to delete message
    When I delete the appliance category
    Then I should see a failed to delete message
    When I update the appliance
    Then I should see the updated appliance
    When I remove an image
    Then I should see the updated appliance without the image
    When I remove a file
    Then I should see the updated appliance without the file

  @javascript
  Scenario: Delete
    Given I am logged in as an admin
    And there is an appliance manufacturer
    And there is an appliance
    When I delete the appliance
    Then I should see the appliance deletion complete successfully
