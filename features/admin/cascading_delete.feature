@javascript @poke
Feature: Cascading delete
  As an admin
  I want to delete a developer
  And see all its children are removed

  Scenario:
    Given I am logged in as a CF Admin wanting to manage plot rooms
    Given there are contacts
    And there are how-tos
    And there is a finish
    And there are faqs
    And there is an appliance manufacturer
    And there is an appliance
    When I delete the developer
    Then I should see most of the children have been removed from the database
