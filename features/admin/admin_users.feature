@javascript @slow
Feature: Admin Users
  As an admin user
  I want to invite other admin users
  So that they can use the system

  Scenario: CF Admin CRUD
    Given I am logged in as a CF Admin
    And I am on the Admin Users page

    When I add a new CF Admin
    Then I should see the new CF Admin
    When I update the CF Admin
    Then I should see the updated CF Admin
    When I delete the updated CF Admin
    Then I should not see the deleted CF Admin

  Scenario: CF Admin
    Given I am logged in as a CF Admin
    And I am on the Admin Users page

    When I add a new Developer Admin
    Then I should see the new Developer Admin

    When I add a new Division Admin
    Then I should see the new Division Admin

    When I add a Development Admin
    Then I should see the new Development Admin

    When I add a (division) Development Admin
    Then I should see the new (division) Development Admin

  Scenario: Developer Admin
    Given I am logged in as a Developer Admin
    And I am on the Admin Users page

    When I add a new Developer Admin
    Then I should see the new Developer Admin

    When I add a new Division Admin
    Then I should see the new Division Admin

    When I add a Development Admin
    Then I should see the new Development Admin

    When I add a (division) Development Admin
    Then I should see the new (division) Development Admin

  Scenario: Division Admin
    Given I am logged in as a Division Admin
    And I am on the Admin Users page

    When I add a new Division Admin
    Then I should see the new Division Admin

    When I add a (division) Development Admin
    Then I should see the new (division) Development Admin

  Scenario: Development Admin
    Given I am logged in as a Development Admin
    And I am on the Admin Users page

    When I add a Development Admin
    Then I should see the new Development Admin

  Scenario: (Division) Development Admin
    Given I am logged in as a Development Admin for a Division
    And I am on the Admin Users page

    When I add a (division) Development Admin
    Then I should see the new (division) Development Admin
