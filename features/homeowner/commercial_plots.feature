@slow
Feature: Commercial Plots
  As an end user
  When my plot is set as a commercial plot
  Then I do not see any referenced to my home

  @javascript
  Scenario:
    Given I am logged in as a homeowner want to download my documents
    And my plot has been marked as commercial
    Then I should not see any reference to my home on the dashboard
    And I should see references to my commercial name
    When I navigate to my documents
    Then I do not see the category my home
    And I see a category named after my commercial name
