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

  Scenario Outline: CAS Create appliance category
    Given I am logged in as a <role> with CAS
    And there is an appliance manufacturer
    And there is an appliance
    When I create a ApplianceCategoryFixture.name appliance category
    Then I should see the ApplianceCategoryFixture.name appliance category
    When I update the appliance category
    Then I should see the ApplianceCategoryFixture.updated_name appliance category
    Examples:
      | role              |
      | Developer Admin   |
      | Development Admin |
      | Site Admin        |

  Scenario: Test deleting the CF Admin appliance category
    Given I am logged in as an admin
    And there is an appliance category
    When I delete the CreateFixture.appliance_category_name appliance category
    Then I should see the CreateFixture.appliance_category_name appliance category delete complete successfully

  Scenario Outline: CAS duplicating, creating, deleting appliance categories
    Given I am logged in as a <role> with CAS
    # A CF admin appliance category
    And there is an appliance category
    # Which a CAS admin should be able to see but not delete
    Then I should see the CreateFixture.appliance_category_name appliance category
    Then I cannot delete the CreateFixture.appliance_category_name appliance category
    # CAS creates one of the same name
    When I create a CreateFixture.appliance_category_name appliance category
    # CAS can read/delete their copy
    Then I should see the CreateFixture.appliance_category_name appliance category
    When I delete the CreateFixture.appliance_category_name appliance category
    Then I should see the CreateFixture.appliance_category_name appliance category delete complete successfully
    # After deletion the CF copy is listed instead
    Then I should see the CreateFixture.appliance_category_name appliance category
    # Create and delete a unique CAS only category
    When I create a ApplianceCategoryFixture.name appliance category
    Then I should see the ApplianceCategoryFixture.name appliance category
    When I delete the ApplianceCategoryFixture.name appliance category
    Then I should see the ApplianceCategoryFixture.name appliance category delete complete successfully
    Examples:
      | role              |
      | Developer Admin   |
      | Development Admin |
      | Site Admin        |

  Scenario Outline: Non CAS admins cannot see Appliances
    Given I am logged in as a <role>
    Then I should not see appliance categories
    | role              |
    | Developer Admin   |
    | Development Admin |
    | Site Admin        |

