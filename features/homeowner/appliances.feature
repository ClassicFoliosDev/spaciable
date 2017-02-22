Feature: Homeowner Appliances
  As a homeowner
  I want to log into Hoozzi
  To look at the configuration of my home appliances

  Scenario:
    Given I have created a unit_type
    And I have seeded the database
    And I have created an appliance
    And I have created an appliance_room
    And I have logged in as a resident and associated the plot
    When I visit the appliances page
    Then I should see the appliances for my plot
