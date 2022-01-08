@javascript @poke
Feature: Appliances
  As a CF Admin
  I want to add appliances
  So that I can add them to rooms and the home owner knows what they are getting

  Scenario:
    Given I am logged in as an admin
    And I have seeded the database with appliances
    When I create an appliance with no name
    Then I should see the appliance model num error
    When I create an appliance with no category
    Then I should see the appliance category error
    When I create an appliance
    Then I should see the new ApplianceFixture.model_num appliance
    When I delete the CreateFixture.appliance_manufacturer_name appliance manufacturer
    Then I should see a failed to delete message
    When I delete the CreateFixture.appliance_category_name appliance category
    Then I should see a failed to delete message
    When I try to clone the ApplianceFixture.model_num appliance
    Then I cannot produce a duplicate appliance
    When I update the appliance name to ApplianceFixture.clone_model_num
    Then I can see a ApplianceFixture.clone_model_num appliance
    Then I delete the ApplianceFixture.clone_model_num appliance
    When I update the appliance
    Then I should see the updated appliance
    When I remove an image
    Then I should see the updated appliance without the image
    When I remove a file
    Then I should see the updated appliance without the file

  Scenario Outline: CAS admins create/update/delete appliance
    Given I am logged in as a <role> with CAS
    And I have seeded the database with appliances
    When I create an appliance with no name
    Then I should see the appliance model num error
    When I create an appliance with no category
    Then I should see the appliance category error
    And there is a CreateFixture.appliance_manufacturer_name appliance manufacturer
    And there is a CreateFixture.appliance_category_name appliance category
    When I create an appliance
    Then I should see the new ApplianceFixture.model_num appliance
    When I update the appliance
    Then I should see the updated appliance
    When I remove an image
    Then I should see the updated appliance without the image
    When I remove a file
    Then I should see the updated appliance without the file
    When I try to clone the ApplianceFixture.updated_model_num appliance
    Then I cannot produce a duplicate appliance
    When I update the appliance name to ApplianceFixture.clone_model_num
    Then I can see a ApplianceFixture.clone_model_num appliance
    Examples:
      | role              |
      | Developer Admin   |
      | Division Admin    |
      | Development Admin |
      | Site Admin        |

  Scenario: Delete
    Given I am logged in as an admin
    And there is an appliance manufacturer
    And there is a CreateFixture.appliance_name appliance for developer nil
    When I delete the CreateFixture.appliance_name appliance
    Then I should see the CreateFixture.appliance_name appliance deletion complete successfully

  Scenario Outline: CAS Admin Delete
    Given I am logged in as a <role> with CAS
    And there is an appliance manufacturer
    # Can see but not delete a CF admin appliance
    And there is a CreateFixture.appliance_name appliance for developer nil
    Then I cannot delete the CreateFixture.appliance_name appliance
    # Create and delete a duplicate developer appliance
    And there is a CreateFixture.developer_appliance_name appliance for developer CreateFixture.developer
    When I delete the CreateFixture.developer_appliance_name appliance
    Then I should see the CreateFixture.developer_appliance_name appliance deletion complete successfully
    Examples:
      | role              |
      | Developer Admin   |
      | Division Admin    |
      | Development Admin |
      | Site Admin        |
