@poke
Feature: Seeds
  As an administrator
  I want to be able to run the seeds
  So that I can deploy builds

  Scenario: Existing seeds
    Given I am logged in as a CF Admin
    And There are existing appliances
    When I have seeded the database
    Then I should not see the seed appliance updates
    When I have seeded the database
