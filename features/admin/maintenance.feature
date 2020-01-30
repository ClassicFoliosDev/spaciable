@poke @javascript
Feature: Maintenance
  As an CF admin
  I want to create a maintenance record for a development

  Scenario: Development with maintenance
    Given I am logged in as an admin
    And there is a developer
    When I create a development for the developer
    Then I should see the created developer development
    Given I update the development to have maintenance
    And I do not enter an account type
    Then I see an error that I need to enter an account type
    When I enter an account type
    Then I see the maintenance record has been created
    Given I update the maintenance for the development
    Then I see the maintenance record has been updated
