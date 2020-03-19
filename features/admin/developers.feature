@javascript @poke
Feature: Developers
  As a CF Admin
  I want to add developers
  So that we can invite our clients to use our application

  Scenario: Create and delete developer
    Given I am logged in as an admin
    When I create a developer
    Then I should see the created developer
    When I update the developer
    Then I should see the updated developer
    When I try to delete the developer with an incorrect password
    Then I see an alert and the developer is not deleted
    When I delete the developer
    Then I should see the delete complete successfully

  Scenario: Cloned Default FAQs for new Developers
    Given I am logged in as an admin
    And default FAQs exist
    When I create a developer
    Then I should see default faqs for the developer

  Scenario: Create Spanish developer
    Given I am logged in as an admin
    When I open the new developer page
    Then I should see UK address format
    When I create a new spanish developer and edit it
    Then I should see Spanish address format

