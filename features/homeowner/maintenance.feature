Feature: Homeowner Maintenance
  As a homeowner
  I want to visit the maintenance page
  To raise a defect about my home

  @javascript
  Scenario:
    Given I have created a unit_type
    And I have logged in as a resident and associated the plot
    When I visit the maintenance page
    Then I should see the fixflo page
