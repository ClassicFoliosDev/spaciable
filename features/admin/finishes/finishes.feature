@javascript @poke
Feature: Finishes
  As a CF Admin
  I want to create finishes
  So that I can add them to make rooms more descriptive

  Scenario:
    Given I am logged in as an admin
    And I have seeded the database
    And I create a finish without a category
    Then I should see the category failure message
    When I create a finish
    Then I should see the created finish
    When I delete the finish manufacturer
    Then I should see successfully deleted message
    When I review the finish category
    Then I should see the finish type shown
    When I delete the finish category
    Then I should see a failed to delete message
    When I review the finish type
    Then I should see the finish manufacturer shown
    When I delete the CreateFixture.seed_finish_type_name finish type
    Then I should see a failed to delete message
    When I update the finish
    Then I should see the updated finish
    When I remove an image from a finish
    Then I should see the updated finish without the image

  Scenario: duplicate finish/type/man combos
    Given I am logged in as an admin
    And I have seeded the database
    And I create a CreateFixture.finish_name finish with category CreateFixture.finish_category_name type CreateFixture.seed_finish_type_name and manufacturer CreateFixture.seeded_finish_manufacturer_name
    And I try to clone the CreateFixture.finish_name finish
    Then I cannot produce an exact duplicate
    When I update the finish name to CreateFixture.finish_dup_name
    Then I can see a CreateFixture.finish_dup_name finish

  Scenario Outline: CAS admin duplicate finish/type/man combos
    Given I am logged in as a <role> with CAS
    And I have seeded the database as a developer
    Given I have created a finish
    When I view the finishes
    Then I do not see a I18n.t("finishes.collection.finish_types") tab
    And I do not see a I18n.t("finishes.collection.finish_categories") tab
    When I try to clone the CreateFixture.finish_name finish
    Then I cannot produce an exact duplicate
    When I update the finish name to CreateFixture.finish_dup_name
    Then I can see a CreateFixture.finish_dup_name finish
    And I create a CreateFixture.developer_finish_name finish with category CreateFixture.finish_category_name type CreateFixture.seed_finish_type_name and manufacturer CreateFixture.seeded_finish_manufacturer_name
    Then I create a CreateFixture.finish_dup_name finish with category CreateFixture.finish_category_name type CreateFixture.seed_finish_type_name and manufacturer CreateFixture.seeded_finish_manufacturer_name
    Examples:
      | role              |
      | Developer Admin   |
      | Division Admin    |
      | Development Admin |
      | Site Admin        |

  Scenario: Delete
    Given I am logged in as an admin
    And I have created a finish
    When I delete the finish
    Then I should see the finish deletion complete successfully

  Scenario Outline: CAS Admins
    Given I am logged in as a <role> with CAS
    And I have seeded the database as a developer
    And I create a finish without a category
    Then I should see the category failure message
    When I create a finish
    Then I should see the created finish
    When I delete the finish manufacturer
    Then I should see successfully deleted message
    When I review the finish category
    Then I should see the finish type shown
    When I review the finish type
    Then I should see the finish manufacturer shown
    When I update the finish
    Then I should see the updated finish
    When I remove an image from a finish
    Then I should see the updated finish without the image
    Examples:
      | role              |
      | Developer Admin   |
      | Division Admin    |
      | Development Admin |
      | Site Admin        |

  Scenario Outline: CAS Delete
    Given I am logged in as a <role> with CAS
    And I have created a developer finish
    When I delete the finish
    Then I should see the finish deletion complete successfully
    Examples:
      | role              |
      | Developer Admin   |
      | Division Admin    |
      | Development Admin |
      | Site Admin        |

