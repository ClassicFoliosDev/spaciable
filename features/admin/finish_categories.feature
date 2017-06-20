Feature: Developers
  As a CF Admin
  I want to add finish_categories
  So that I can use them when I create a new finish

  @javascript
  Scenario: Create finish_category
    Given I am logged in as an admin
    And there is a manufacturer
    When I create a finish_category
    Then I should see the created finish_category
    When I update the finish_category
    Then I should see the updated finish_category

  @javascript
  Scenario: Test using and deleting the appliance_category
    Given I am logged in as an admin
    And there is a finish_category
    When I delete the finish_category
    Then I should see the finish_category delete complete successfully

  Scenario: Developer
    Given I am logged in as a Developer Admin
    Then I should not see finish_categories
