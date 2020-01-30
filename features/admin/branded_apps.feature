@javascript @poke
Feature: Branded App
  As a CF Admin
  I want to allocate a branded app to a developer

  Scenario:
    Given I am logged in as an admin
    When I create a developer
    Then I should see the created developer
    And I cannot see the branded app tab
    And no branded app record should be created
    When I update the branded app developer
    Then I can see the branded app tab
    And the branded app record has been created
    When I update the branded app with invalid data
    Then I see an error that I cannot update the branded app
    When I update the branded app with valid data
    Then I see the branded app data has been updated
    And the branded app record has been updated
    When I update the branded app developer and uncheck branded app
    Then I cannot see the branded app tab
    And the branded app record has been deleted