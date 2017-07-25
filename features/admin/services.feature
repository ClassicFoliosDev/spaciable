@javascript @slow
Feature: FAQs
  As an Admin
  I want to CRUD services for developments
  So that homeowners can see services available for their development

  Scenario: CF Admin
    Given I am logged in as a CF Admin
    When I create a service
    Then I should see the created service
    When I update the service
    Then I should see the updated service
    When I delete the service
    Then I should no longer see the service

  Scenario: Developer Admin
    Given I am logged in as a Developer Admin
    Then I should not see the services tab

  Scenario: Division Admin
    Given I am logged in as a Division Admin
    Then I should not see the division development services tab

  Scenario: Development Admin
    Given I am logged in as a Development Admin
    Then I should not see the services tab

  Scenario: (Division) Development Admin
    Given I am logged in as a Development Admin for a Division
    Then I should not see the division development services tab

