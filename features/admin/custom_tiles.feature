@javascript @slow
Feature: Custom Tiles
  As an admin user
  I want to modify the dashboard tiles

  Scenario: Site Admin
    Given I am logged in as a Site Admin
    When I navigate to my development
    And I visit the custom shortcuts tab
    Then I see the referrals shortcut
    And I cannot crud the shortcuts
    And I can preview the referrals the shortcut

  Scenario: Shortcut creation on development creation
    Given I am logged in as a Development Admin
    When I navigate to my development
    And I visit the custom shortcuts tab
    Then I see the referrals shortcut

  Scenario: Feature shortcuts
    Given I am logged in as a Division Admin
    When I navigate to a development
    And I visit the custom shortcuts tab
    Then I can add a new shortcut
    And I can only select features that are turned on for the development
    When I select a feature
    And I save the tile
    Then I see the feature tile in my custom tiles collection

  Scenario: Document shortcuts
    Given I am logged in as a Development Admin
    And there is a phase plot with a resident
    And there are documents
    When I navigate to my development
    And I visit the custom shortcuts tab
    Then I can add a new shortcut
    When I select the document category
    Then there is a list of documents associated with my development
    When I enter a title and description
    And I save the tile
    Then I see an error message
    When I enter button text
    And I save the tile
    Then I see the document shortcut

  Scenario: Edit shortcut link
    Given I am logged in as a Division Admin
    When I navigate to a development
    And I visit the custom shortcuts tab
    When I edit the existing shortcut
    And I change the category to a link
    And I enter a link
    And I enter content
    When I save the tile
    Then I see the link tile shortcut
    And the link tile has been updated

  Scenario: Maximum shortcuts
    Given I am logged in as a Development Admin
    And there are five custom shortcuts for my development
    When I navigate to my development
    And I visit the custom shortcuts tab
    Then I cannot add another shortcut
    When I delete a shortcut
    Then I can add another shortcut