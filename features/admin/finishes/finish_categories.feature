Feature: Developers
  As a CF Admin
  I want to add finish_categories
  So that I can use them when I create a new finish

  @javascript @slow
  Scenario: Create finish_category
    Given I am logged in as an admin
    And there is a finish manufacturer
    When I create a finish category
    Then I should see the created finish category
    When I update the finish category
    Then I should see the updated finish category

  @javascript @slow
  Scenario: Test using and deleting the finish category
    Given I am logged in as an admin
    And there is a finish category
    When I delete the finish category
    Then I should see the finish category delete complete successfully

  Scenario: Developer
    Given I am logged in as a Developer Admin
    Then I should not see finish categories
