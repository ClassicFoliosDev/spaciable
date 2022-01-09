@javascript @poke
Feature: Developers
  As a CF Admin
  I want to add finish types
  So that I can use them when I create a new finish

  Scenario: Create finish_type
    Given I am logged in as an admin
    And there is a finish category
    When I create a finish type
    Then I should see the created finish type
    When I update the finish type
    Then I should see the updated finish type
    When I create a finish with the new finish type
    Then I should see the finish created successfully

  Scenario: Test using and deleting the finish type
    Given I am logged in as an admin
    And there is a finish type
    When I delete the CreateFixture.finish_type_name finish type
    Then I should see the CreateFixture.finish_type_name finish type delete complete successfully

  Scenario Outline: Non CF Admins should not see Finish types
    Given I am logged in as a <role>
    Then I should not see finish types
    Examples:
      | role              |
      | Developer Admin   |
      | Division Admin    |
      | Development Admin |
      | Site Admin        |
