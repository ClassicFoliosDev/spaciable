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
    When I add a new CF Admin
    Then I should see the restored CF Admin

  Scenario Outline: CF Admin
    Given I am logged in as a CF Admin
    And the developer has CAS <status>
    And I am on the Admin Users page
    When I add a new Developer Admin user
    Then I should see the new Developer Admin user
    When I update the new admin
    Then I should see the updated admin
    When I add a new Division Admin user
    Then I should see the new Division Admin user
    When I add a new Development Admin user
    Then I should see the new Development Admin user
    When I add a new Division Development Admin user
    Then I should see the new Division Development Admin user
    When I delete the developer admin
    Then I should not see the deleted developer admin
    When I restore the deleted developer admin as CF admin
    Then I should see the recreated CF admin
    Examples:
      | status   |
      | enabled  |
      | disabled |

  Scenario: Users view
    Given I am logged in as a CF Admin
    And I add a new Developer Admin user
    And I add a new Division Admin user
    And I add a new Development Admin user
    And I log out as a an admin
    Given I accept the invitation as development admin
    And I log out as a an admin
    When I log in as CF Admin
    And I visit the users page
    Then I see the activated users

  Scenario: Developer Admin
    Given I am logged in as a Developer Admin
    And I am on the Admin Users page
    When I add a new Developer Admin user
    Then I should see the new Developer Admin user
    When I add a new Division Admin user
    Then I should see the new Division Admin user
    When I add a new Development Admin user
    Then I should see the new Development Admin user
    When I add a new Division Development Admin user
    Then I should see the new Division Development Admin user
    When I delete the developer admin
    Then I should not see the deleted developer admin
    When I change my password
    Then I should be logged out

  Scenario: Division Admin
    Given I am logged in as a Division Admin
    And I am on the Admin Users page
    When I add a new Division Admin user
    Then I should see the new Division Admin user
    When I add a new Division Development Admin user
    Then I should see the new Division Development Admin user
    When I delete the division admin
    Then I should not see the deleted division admin

  Scenario: Development Admin
    Given I am logged in as a Development Admin
    And I am on the Admin Users page
    When I add a new Development Admin user
    Then I should see the new Development Admin user
    When I delete the development admin
    Then I should not see the deleted development admin

  Scenario: new Division Development Admin user
    Given I am logged in as a Development Admin for a Division
    And I am on the Admin Users page
    When I add a new Division Development Admin user
    Then I should see the new Division Development Admin user
    When I delete the division development admin
    Then I should not see the deleted division development admin
    When I change my password
    Then I should be logged out

  Scenario: Admin lettings
    Given I am logged in as a CF Admin
    And that I have developer, division and development users
    When I edit the developer details
    Then I can set the primary developer admin
    When I edit the division details
    Then I can set the primary division admin
    When I log out as an admin
    And I log in as the primary developer admin
    Then I can enable my developer development users to perform lettings
    When I log out as an admin
    And I log in as the non primary developer admin
    Then I cannot enable my developer development users to perform lettings
    When I log out as an admin
    And I log in as the primary division admin
    Then I can enable my division development users to perform lettings
    When I log out as an admin
    And I log in as the non primary division admin
    Then I cannot enable my division development users to perform lettings
