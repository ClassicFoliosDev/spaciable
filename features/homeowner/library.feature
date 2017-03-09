Feature: My Home Library
  As a homeowner
  I want to see all the documents related to the home I have purchased
  So that I can efficiently gather the information I need

  Scenario:
    Given I am logged in as a homeowner want to download my documents
    Then I should see recent documents added to my library
    When I go to download the documents for my home
    Then I should see all of the documents related to my home

    When I filter my documents by a different category
    Then I should only see the documents for the other category

    When I filter the documents by appliances
    Then I should only see the appliance manuals to download
