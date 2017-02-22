Feature: Homeowner Branding
  As a homeowner
  When I log into Hoozzie
  I want to see the branding configured by my developer

  Scenario:
    Given I have a developer with a development with unit type and plot
    And I have configured branding
    And I have logged in as a resident and associated the division development plot
    When I visit the dashboard
    Then I should see the branding for my page
