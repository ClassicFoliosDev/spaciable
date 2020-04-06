@javascript @poke
Feature: Developers
  As a CF Admin
  I want to add manufacturers
  So that I can use them when I create a new appliance

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

  Scenario Outline: CAS Admins Create manufacturer
    Given I am logged in as a <role> with CAS
    And there is an appliance category
    When I create an appliance manufacturer
    Then I should see the created appliance manufacturer
    When I create an appliance with the new appliance manufacturer
    Then I should see the appliance with manufacturer created successfully
    When I update the appliance manufacturer
    Then I should see the updated appliance manufacturer
    And I should see the appliance that uses it has been updated
    Examples:
      | role              |
      | Developer Admin   |
      | Development Admin |
      | Site Admin        |

  Scenario: Test deleting the appliance_manufacturer
    Given I am logged in as an admin
    And there is an appliance manufacturer
    When I delete the CreateFixture.appliance_manufacturer_name appliance manufacturer
    Then I should see the appliance manufacturer delete complete successfully

  Scenario Outline: CAS Test deleting the appliance_manufacturer
    Given I am logged in as a <role> with CAS
    And there is a CreateFixture.appliance_manufacturer_name appliance manufacturer for developer nil
    And there is a CreateFixture.developer_appliance_manufacturer_name appliance manufacturer for developer CreateFixture.developer
    Then I cannot delete the CreateFixture.appliance_manufacturer_name appliance manufacturer
    Then I delete the CreateFixture.developer_appliance_manufacturer_name appliance manufacturer
    Then I should see the CreateFixture.developer_appliance_manufacturer_name appliance manufacturer delete complete successfully
    Examples:
      | role              |
      | Developer Admin   |
      | Development Admin |
      | Site Admin        |

  Scenario Outline: non CAS Admins access
    Given I am logged in as a <role>
    Then I should not see appliance manufacturers
    Examples:
      | role              |
      | Developer Admin   |
      | Development Admin |
      | Site Admin        |

