Feature: My Home Library
  As a homeowner
  I want to see all the documents related to the home I have purchased
  So that I can efficiently gather the information I need

  @javascript
  Scenario:
    Given I am logged in as a homeowner want to download my documents
    And there is an appliance with a guide
    And there is another phase plot
    Then I should see recent documents added to my library
    When I go to download the documents for my home
    Then I should see all of the documents related to my home

    When I filter my documents by a different category
    Then I should only see the documents for the other category

    When I filter the documents by appliances
    Then I should only see the appliance manuals to download

    When I show the plots
    And I switch to the second plot
    Then I should not see plot documents in the dashboard
    When I visit the library page
    Then I should not see plot documents
    When I show the plots
    When I switch to the first plot
    Then I should see recent documents added to my library
