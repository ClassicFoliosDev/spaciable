Feature: Homeowner MyHome
  As a homeowner
  I want to log into Hoozzi
  To look at the configuration of my home

  Scenario:
    Given I have created a plot
    And I have logged in as a resident
    When I visit the My Home page
    Then I should see the plot rooms
