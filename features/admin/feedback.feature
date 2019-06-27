@javascript @poke
Feature: Feedback
  As a user
  I want to provide feedback
  So that I can let the CF team know how great the site is

  Scenario: Developer Admin
    Given I am logged in as a Developer Admin
    When I submit feedback
    Then An email should be sent

  Scenario: Send email
    Given I am logged in as a Developer Admin
    When I submit feedback with email
    Then My email should be sent

  Scenario: Division Admin
    Given I am logged in as a Division Admin
    When I submit feedback
    Then An email should be sent

  Scenario: Development Admin
    Given I am logged in as a Development Admin
    When I submit feedback
    Then An email should be sent

  Scenario: Homeowner
    Given I am logged in as a homeowner
    When I submit feedback
    Then An email should be sent
