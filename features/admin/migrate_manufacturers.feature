Feature: Manufaturer migrations
  As a Sys Admin
  I want to migrate manufacturers
  So that old manufacturer relationships are patched up

  Scenario: Sys Admin
  Given I have seeded the database with old manufacturers
  And I have created appliances and finishes with old manufacturers
  When I migrate the old manufacturers
  Then I should find new appliance manufacturers
  And I should find new finish manufacturers
  And I should find the old appliance relationships have been updated
  And I should find the old finish relationships have been updated
