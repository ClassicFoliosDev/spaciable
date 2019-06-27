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
    When I delete the finish type
    Then I should see the finish type delete complete successfully

  Scenario: Developer
    Given I am logged in as a Developer Admin
    Then I should not see finish categories
