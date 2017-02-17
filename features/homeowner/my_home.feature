Feature: Homeowner MyHome
  As a homeowner
  I want to log into Hoozzi
  To look at the configuration of my home

  Scenario:
    Given I have created a unit_type
    And I have logged in as a resident and associated the plot
    When I visit the My Home page
    Then I should see the plot rooms
