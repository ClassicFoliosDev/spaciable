@javascript @poke
Feature: Lettings
  As a homeowner
  I want to manage my letable plots

  Scenario: No letable plots
    Given I am logged in as a homeowner
    And I have no letable plots
    Then I cannot see the lettings link

  Scenario: Letable plot
    Given I am logged in as a homeowner
    And I have letable and unletable plots
    When I navigate to the lettings page
    Then I can see my letable plot
    And I cannot see my unletable plot
    Given one of my plots is let
    Then I can see that it is let