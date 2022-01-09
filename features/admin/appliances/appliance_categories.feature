@javascript @poke
Feature: Developers
  As an Admin
  I want to add appliance categories
  So that I can use them when I create a new appliance

  Scenario: Create appliance category
    Given I am logged in as an admin
    And there is an appliance manufacturer
    And there is an appliance
    When I create a ApplianceCategoryFixture.name appliance category
    Then I should see the ApplianceCategoryFixture.name appliance category
    When I update the appliance category
    Then I should see the ApplianceCategoryFixture.updated_name appliance category

  Scenario: Test deleting the CF Admin appliance category
    Given I am logged in as an admin
    And there is an appliance category
    When I delete the CreateFixture.appliance_category_name appliance category
    Then I should see the CreateFixture.appliance_category_name appliance category delete complete successfully

  Scenario Outline: Non CAS admins cannot see Appliances
    Given I am logged in as a <role>
    Then I should not see appliance categories
    | role              |
    | Developer Admin   |
    | Development Admin |
    | Site Admin        |

