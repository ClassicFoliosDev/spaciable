Feature: Developers
  As a CF Admin
  I want to add manufacturers
  So that I can use them when I create a new finish

  Scenario: Create manufacturer
    Given I am logged in as an admin
    And there is a finish category
    And there is a finish type
    When I create a finish manufacturer
    Then I should be required to enter a finish type
    Then I should see the created finish manufacturer
    When I update the finish manufacturer
    Then I should see the updated finish manufacturer

  Scenario: Developer
    Given I am logged in as a Developer Admin
    Then I should not see finish manufacturers

