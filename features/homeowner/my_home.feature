@javascript @poke
Feature: Homeowner MyHome
  As a homeowner
  When I log in
  I want to see the configuration of my home

  Scenario:
    Given I have created a unit_type
    And I have logged in as a resident and associated the plot
    And there is another plot
    When I visit the My Home page
    Then I should see the plot rooms
    When I show the plots
    And I switch to the second plot
    When I visit the My Home page
    Then I should see no rooms or appliances
    When I show the plots
    When I switch back to the development plot
    When I visit the My Home page
    Then I should see the plot rooms
    When I visit the Library page
    Then I should see My Documents
    When I visit the Contacts page
    Then I should see no tabs

  Scenario:
    Given I am logged in as a homeowner
    And there is another tenant on the homeowner plot
    Then I should see the tenant on my account
    When I log out as a homeowner
    And I log in as a tenant
    Then I should not see the homeowner on my account