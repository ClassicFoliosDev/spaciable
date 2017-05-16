@javascript
Feature: Divisions
  As a CF Admin
  I want to add our clients divisions
  So that we can distinguish between sub-divisions within the customer's parent group

  Scenario: Divisions
    Given I am logged in as an admin
    And I have configured an API key
    And there is a developer with divisions
    When I create a division for the developer
    Then I should see the created developer division
    When I update the developer's division
    Then I should see the updated developer division
    When I create another division
    Then I should see the divisions list
    When I delete the division
    Then I should see that the deletion was successful for the division
