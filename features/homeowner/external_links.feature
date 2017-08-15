Feature: Homeowner external links
  As a homeowner
  I want to see links to external sites
  When they have been configured by my developers

  @javascript
  Scenario:
    Given I have created a unit_type
    And I have logged in as a resident and associated the plot
    Then I should see the bafm link
    When I visit the maintenance page
    Then I should see the fixflo page
