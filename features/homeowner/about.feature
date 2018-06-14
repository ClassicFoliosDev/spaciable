Feature: Homeowner MyHome
  As a homeowner
  I want to log into the site
  To look at the configuration of my home

  Scenario:
    Given I have created a unit_type
    And I have logged in as a resident and associated the plot
    When I visit the About page
    Then I should see the about page links


