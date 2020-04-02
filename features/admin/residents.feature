@poke @javascript
Feature: Residents
  As an admin user
  I want to see a list / show view for residents
  So I can work out which development a resident belongs to

  Scenario: CF Admin
    Given I am logged in as an admin
    And there is a phase plot with a resident
    When I navigate to the residents view
    Then I see a list of residents

  Scenario: Development Admin
    Given I am logged in as a Development Admin
    And there is a phase plot with a resident
    When I navigate to the residents view
    Then I should be on the admin dashboard
