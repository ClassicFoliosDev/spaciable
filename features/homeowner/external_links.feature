@javascript
Feature: Homeowner external links
  As a homeowner
  I want to see links to external sites
  When they have been configured by my developers

  Scenario:
    Given I have created a unit_type
    And I have logged in as a resident and associated the plot
    Then I should see the bafm link
    When I visit the maintenance page
    Then I should see the fixflo page
    When the expiry date is past
    Then I should not see the maintenance link

  Scenario:
    Given I am logged in as a homeowner
    And the developer has enabled roomsketcher
    Then I should see the roomsketcher link

  Scenario:
    Given I am logged in as a homeowner
    And the developer has disabled roomsketcher
    Then I should not see the roomsketcher link