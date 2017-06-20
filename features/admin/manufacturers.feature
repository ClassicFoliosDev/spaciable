Feature: Developers
  As a CF Admin
  I want to add manufacturers
  So that I can use them when I create a new appliance or finish

  @javascript
  Scenario: Create manufacturer
    Given I am logged in as an admin
    And there is a manufacturer
    And there is an appliance
    And there is a finish
    When I create a manufacturer
    Then I should see the created manufacturer
    When I create an appliance with the new manufacturer
    Then I should see the appliance with manufacturer created successfully
    When I update the manufacturer
    Then I should be required to enter a finish category
    Then I should see the updated manufacturer
    When I create a finish with the new manufacturer
    Then I should see the finish with manufacturer created successfully

  @javascript
  Scenario: Delete manufacturer
    Given I am logged in as an admin
    And there is a manufacturer
    When I delete the manufacturer
    Then I should see the manufacturer delete complete successfully

  Scenario: Developer
    Given I am logged in as a Developer Admin
    Then I should not see manufacturers

