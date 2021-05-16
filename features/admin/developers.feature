@javascript @poke
Feature: Developers
  As a CF Admin
  I want to add developers
  So that we can invite our clients to use our application

  Scenario: CAS Create and delete developer
    Given I am logged in as an admin
    When I create a developer
    And the developer has no divisions or developments
    Then I see Divisions as the default developer tab
    When I create a development
    Then I see Developments as the default developer tab
    Then I should not see CAS visable and enabled at the development
    And I should see the created developer
    When I update the developer
    Then I should see the updated developer
    And I should see CAS visable and enabled at the development
    When I try to delete the developer with an incorrect password
    Then I see an alert and the developer is not deleted
    When I delete the developer
    Then I should see the delete complete successfully

  Scenario: Default developer admin tab - divs and devs
    Given I am logged in as a Developer Admin
    And the developer has divisions and developments
    Then I see Divisions as the default developer tab

  Scenario: Default developer admin tab - no divs
    Given I am logged in as a Developer with no divisons
    And the developer has no divisions or developments
    Then I see Developments as the default developer tab

  Scenario: Cloned Default FAQs for new Developers
    Given I am logged in as an admin
    And default FAQs exist
    When I create a developer
    Then I should see default faqs for the developer

  Scenario: Create Spanish developer
    Given I am logged in as an admin
    When I open the new developer page
    When I create a new spanish developer and edit it
    Then I should see Spanish address format

