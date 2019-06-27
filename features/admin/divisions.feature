@javascript @poke
Feature: Divisions
  As a CF Admin
  I want to add our clients divisions
  So that we can distinguish between sub-divisions within the customer's parent group

  Scenario: Divisions
    Given I am logged in as an admin
    And there is a developer with divisions
    When I create a division for the developer
    Then I should see the created developer division
    When I update the developer's division
    Then I should see the updated developer division
    When I create another division
    Then I should see the divisions list
    When I delete the division
    Then I should see that the deletion was successful for the division

  Scenario: Spanish Divisions
    Given I am logged in as an admin
    And there is a Spanish developer with a division
    When I create a division for the spanish developer
    Then I see a Spanish format divison address
