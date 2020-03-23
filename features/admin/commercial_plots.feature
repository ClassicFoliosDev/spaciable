@slow
Feature: Commercial Plots
  As an admin
  I can set plots as commercial at development level

  @javascript
  Scenario:
    Given I am logged in as an admin
    And there is a developer
    When I create a development for the developer
    Then I should see the created developer development
    When I update the development to a commercial development and do not enter a my home replacement
    Then I should see an error telling me to enter a my home replacement
    When I enter a my home replacement
    When I create a phase under the commercial development
    Then the business is commercial and I cannot change it