@javascript @slow
Feature: Spotlights
  As an admin user
  I want to modify the dashboard tiles

  Scenario: Site Admin
    Given I am logged in as a Site Admin
    When I navigate to my development
    And I visit the spotlights tab
    Then I see the referrals spotlight
    And I cannot crud the spotlights
    And I can preview the referrals the spotlight

  Scenario: Spotlight creation on development creation
    Given I am logged in as a Development Admin
    And there are uneditable spotlights
    When I navigate to my development
    And I visit the spotlights tab
    Then I see the referrals spotlight
    And the services spotlight is uneditable

  Scenario: Feature spotlights
    Given I am logged in as a Division Admin
    When I navigate to a development
    And I visit the spotlights tab
    Then I can add a new spotlight
    And I can only select features that are turned on for the development
    When I select a feature
    And I save the tile
    Then I see the feature tile in my custom tiles collection

  Scenario: Document spotlights
    Given I am logged in as a Development Admin
    And there is a phase plot with a resident
    And there are documents
    When I navigate to my development
    And I visit the spotlights tab
    Then I can add a new spotlight
    When I select the document category
    Then there is a list of documents associated with my development
    When I enter a title and description
    And I save the tile
    Then I see an error message
    When I enter button text
    And I save the tile
    Then I see the document spotlight

  Scenario: Edit spotlight link
    Given I am logged in as a Division Admin
    When I navigate to a development
    And I visit the spotlights tab
    When I edit the existing spotlight
    And I change the category to a link
    And I enter a link
    And I enter content
    When I save the tile
    Then I see the link tile spotlight
    And the link tile has been updated

  Scenario: Maximum spotlights
    Given I am logged in as a Development Admin
    And there are five spotlights for my development
    When I navigate to my development
    And I visit the spotlights tab
    Then I cannot add another spotlight
    When I delete a spotlight
    Then I can add another spotlight
