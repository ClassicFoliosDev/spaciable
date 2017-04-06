@javascript @slow
Feature: HowTos
  As an Admin
  I want to CRUD HowTos
  So that homeowners can see relevant and interesting articles

  Scenario: CF Admin
    Given I am logged in as a CF Admin
    And I have seeded the database
    When I create a HowTo
    Then I should see the created HowTo
    When I update the HowTo
    Then I should see the updated HowTo
    When I remove a Tag
    Then I should see the remove complete successfully
    When I delete the HowTo
    Then I should see the how-to deletion complete successfully

  Scenario: Division Admin
    Given I am logged in as a Division Admin
    Then I should not see HowTos
