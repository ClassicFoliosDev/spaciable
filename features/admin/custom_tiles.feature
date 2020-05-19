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

  Scenario: New Shortcut
    Given I am logged in as a Development Admin
    When I navigate to my development
    And I visit the custom shortcuts tab
    Then I see the referrals shortcut
    And I can add a new shortcut
