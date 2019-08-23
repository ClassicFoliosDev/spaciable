@javascript @poke
Feature: Lettings
  As a homeowner
  I want to manage my letable plots

  Scenario: Letable plots with plot let by other resident
    Given I am logged in as a homeowner
    And I have two letable plots
    And I have an unletable plot
    Given one of the plots has had lettings set up by another resident
    When I navigate to the lettings page
    Then I can see the plot that has been set up by the other resident
    And I can set up my self managed lettings account
    Then I can see my management type
    And I can see my letable plot
    And I can see the let plot
    And I cannot see my unletable plot
    When I set up my letable plot for letting
    Then I can see that it is set up

  Scenario: No letable plots
    Given I am logged in as a homeowner
    And I have no letable plots
    Then I cannot see the lettings link

  Scenario: Limited access user
    Given I am logged in as a limited access user
    Then I cannot see the lettings link