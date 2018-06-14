Feature: Homeowner MyHome
  As a homeowner
  When I log in
  I want to see the configuration of my home

  @javascript
  Scenario:
    Given I have created a unit_type
    And I have logged in as a resident and associated the plot
    And there is another plot
    When I visit the My Home page
    Then I should see the plot rooms
    When I show the plots
    And I switch to the second plot
    When I visit the My Home page
    Then I should see no rooms
    When I show the plots
    When I switch back to the development plot
    When I visit the My Home page
    Then I should see the plot rooms
