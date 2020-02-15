@javascript @poke
Feature: Developers
  As a CF Admin
  I want to add developers
  So that we can invite our clients to use our application

  Scenario: CAS Create and delete developer
    Given I am logged in as an admin
    When I create a developer
    And I create a development
    Then I should not see CAS visable and enabled at the development
    And I should see the created developer
    When I update the developer
    Then I should see the updated developer
    And I should see CAS visable and enabled at the development

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

