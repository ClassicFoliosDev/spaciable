Feature: Admin Login
  As an admin user
  I want to log into Hoozzi
  So that I can use the admin area to manage Hoozzi

  Scenario:
    Given I am an admin user
    When I log in as an admin
    Then I should be on the admin dashboard
    Given I am a homeowner
    When I log in as a homeowner
    Then I should be on the "My Home" dashboard

  Scenario: Log out
    Given I am logged in as an admin
    When I log out as a an admin
    Then I should be on the "Admin Login" page
    And I can request an admin password reset

  Scenario: Ts and Cs
    When I visit the admin ts_and_cs page
    Then I should see the terms and conditions for developers using Hoozzi
