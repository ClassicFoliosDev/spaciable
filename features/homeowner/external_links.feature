@javascript @poke
Feature: Homeowner external links
  As a homeowner
  I want to see links to external sites
  When they have been configured by my developers

  Scenario:
    Given I have created a unit_type
    And I have logged in as a resident and associated the plot
    Then I should see the bafm link
    Then I should not see the maintenance link
    Given the plot does have a completion release date
    When I visit the maintenance page
    Then I should see the fixflo page
    When the expiry date is past
    Then I should not see the maintenance link

  Scenario:
    Given I am logged in as a homeowner
    And the developer has enabled home designer
    Then I should see the home designer link
    And when I visit the home designer page
    Then I can see the home designer page

  Scenario:
    Given I am logged in as a homeowner
    And the developer has disabled home designer
    Then I should not see the home designer link
