@javascript @poke
Feature: Homeowner Appliances
  As a homeowner
  When I log in
  I want to see the configuration of my home appliances

  Scenario:
    Given I am logged in as a homeowner want to download my documents
    And FAQ metadata is available
    And there is an appliance with a guide
    And there is a second appliance
    And there is another phase plot
    When I visit the appliances page
    Then I should see the appliances for my plot
    When I show the plots
    And I switch to the second plot
    Then I should see no appliances
    When I show the plots
    When I switch to the first plot
    And I visit the appliances page
    Then I should see the appliances for my plot
