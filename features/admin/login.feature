@poke
Feature: Admin Login
  As an admin user
  I want to log into the site
  So that I can use the admin area to manage the site

  Scenario:
    Given I am an admin user
    When I log in as an admin
    Then I should be on the admin dashboard

  Scenario: Log out
    Given I am logged in as an admin
    When I log out as a an admin
    Then I should be on the "Admin Login" page
    And I can request an admin password reset

