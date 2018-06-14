Feature: Homeowner Login
  As a homeowner
  I want to log in
  So that I can access content related to my plot

  @javascript
  Scenario:
    Given I am a homeowner
    When I log in as a homeowner
    Then I should be on the "My Home" dashboard

  Scenario: Log out
    Given I am logged in as a homeowner
    When I log out as a homeowner
    Then I should be on the branded homeowner login page

  @javascript
  Scenario: Unassociated homeowner
    Given I am a homeowner with no plot
    When I log in as a homeowner
    Then I should be on the "Homeowner Login" page with errors

  Scenario: Reset password
    Given I am a homeowner
    When I can request a password reset
