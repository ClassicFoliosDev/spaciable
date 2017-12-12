Feature: Homeowner Branding
  As a homeowner
  When I log into Hoozzie
  I want to see the branding configured by my developer

  @javascript
  Scenario:
    Given I have a developer with a development with unit type and plot
    And I have configured branding
    And I have logged in as a resident and associated the division development plot
    And the resident also has an unbranded plot
    When I visit the dashboard
    Then I should see the branding for my page
    When I show the plots
    Then I should see the branded logos
    When I switch to the second plot
    Then I should see the default branding
    When I show the plots
    And I switch back to the first plot
    Then I should see the branding for my page
    When I log out as a homeowner
    Then I should see the configured branding
