Feature: Developers
  As a CF Admin
  I want to add finish_types
  So that I can use them when I create a new finish

  @javascript
  Scenario: Create finish_type
    Given I am logged in as an admin
    And there is a manufacturer
    And there is a finish_category
    When I create a finish_type
    Then I should see the created finish_type
    When I update the finish_type
    Then I should see the updated finish_type
    When I create a finish with the new finish_type
    Then I should see the finish created successfully

  @javascript
  Scenario: Test using and deleting the appliance_type
    Given I am logged in as an admin
    And there is a finish_type
    When I delete the finish_type
    Then I should see the finish_type delete complete successfully

  Scenario: Developer
    Given I am logged in as a Developer Admin
    Then I should not see finish_categories
