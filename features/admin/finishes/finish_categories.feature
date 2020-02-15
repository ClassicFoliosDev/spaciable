@javascript @poke
Feature: Developers
  As an Admin
  I want to add finish_categories
  So that I can use them when I create a new finish

  Scenario: Create finish_category
    Given I am logged in as an admin
    And there is a finish manufacturer
    When I create a finish category
    Then I should see the created finish category
    When I update the finish category
    Then I should see the updated finish category

  Scenario: Test using and deleting the finish category
    Given I am logged in as an admin
    And there is a finish category
    When I delete the finish category
    Then I should see the finish category delete complete successfully

  Scenario Outline: Non CF Admins should not see Finishes
    Given I am logged in as a <role>
    Then I should not see finish categories
    Examples:
      | role              |
      | Developer Admin   |
      | Division Admin    |
      | Development Admin |
      | Site Admin        |

  Scenario Outline: Non CF Admin roles with CAS can CRUD finishes
    Given I am logged in as a <role> with CAS
    Then I should see an empty list of finish categories
    When I create a finish category
    Then I should see the created finish category
    When I update the finish category
    Then I should see the updated finish category
    When I delete the updated finish category
    Then I should see the updated finish category delete complete successfully
    Examples:
      | role              |
      | Developer Admin   |
      | Division Admin    |
      | Development Admin |
      | Site Admin        |