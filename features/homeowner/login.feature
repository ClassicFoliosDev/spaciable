Feature: Homeowner Login
  As a homeowner
  I want to log into Hoozzi
  So that I can access documents related to my plot

  Scenario:
    Given I am a homeowner
    When I log in as a homeowner
    Then I should be on the "My Home" dashboard

  Scenario: Log out
    Given I am logged in as a homeowner
    When I log out as a homeowner
    Then I should be on the branded homeowner login page

  Scenario: Unassociated homeowner
    Given I am a homeowner with no plot
    When I log in as a homeowner
    Then I should be on the "Homeowner Login" page with errors

  Scenario: Data policy
    When I visit the data policy page
    Then I should see the data policy contents

  Scenario: Ts and Cs
    When I visit the ts_and_cs page
    Then I should see the terms and conditions for using Hoozzi

  Scenario: Reset password
    Given I am a homeowner
    When I can request a password reset

