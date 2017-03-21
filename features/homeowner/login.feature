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
    Then I should be on the "Homeowner Login" page

  Scenario: Unassociated homeowner
    Given I am a homeowner with no plot
    When I log in as a homeowner
    Then I should be on the "Homeowner Login" page with errors


