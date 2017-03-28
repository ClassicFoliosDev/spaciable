Feature: Homeowner Appliances
  As a homeowner
  I want to log into Hoozzi
  To look at the configuration of my home appliances

  Scenario:
    Given I am logged in as a homeowner want to download my documents
    And I have an appliance with a guide
    When I visit the appliances page
    Then I should see the appliances for my plot
