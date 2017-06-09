@javascript
Feature: Documents
  As a CF Admin
  I want to search for appliances and finishes
  So that I can navigate more easily

  Scenario: CF Admin
    Given I am logged in as an admin
    And there is a finish
    And there is an appliance
    When I search for a search term
    Then I should see the finish in the search results
    And I should be able to navigate to the finish
    When I search for a partial search term
    Then I should see the appliance in the search results
    And I should be able to navigate to the appliance
    When there are no matches
    Then I should see no matches
    When I delete the finish
    When I search for a search term
    Then I should see no matches

  Scenario: Developer Admin
    Given I am logged in as a Developer Admin
    Then I should not see the search widget



