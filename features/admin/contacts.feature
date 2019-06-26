@javascript @slow

Feature: Contacts
  As a CF Admin
  I want to create contacts
  So that homeowners know who to contact for help

  Scenario: Developer
    Given I am logged in as an admin
    And there is a developer
    When I create a contact with no email or phone
    Then I should see the contact create fail
    When I create a contact
    Then I should see the created contact
    When I update the contact
    Then I should see the updated contact
    When I remove an image from a contact
    Then I should see the updated contact without the image
    When I delete the contact
    Then I should see the contact deletion complete successfully

  Scenario: Division
    Given I am logged in as an admin
    And there is a developer with a division
    When I create a division contact with no email or phone
    Then I should see the contact create fail
    When I create a contact
    Then I should see the created contact
    When I update the contact
    Then I should see the updated contact
    When I remove an image from a contact
    Then I should see the updated contact without the image
    When I delete the division contact
    Then I should see the contact deletion complete successfully

  Scenario: Development
    Given I am logged in as an admin
    And there is a developer with a development
    And there is a phase plot resident
    When I create a development contact with no name or organisation
    Then I should see the contact create fail
    When I create a contact
    Then I should see the created contact
    And I update the contact
    Then I should see the updated contact
    And I should see the contact resident has been notified
    When I remove an image from a contact
    Then I should see the updated contact without the image
    When I delete the development contact
    Then I should see the contact deletion complete successfully

  Scenario: Phase
    Given I am logged in as an admin
    And there is a phase
    When I create a phase contact with no email or phone
    Then I should see the contact create fail
    When I create a contact
    Then I should see the created contact
    And I update the contact
    Then I should see the updated contact
    When I remove an image from a contact
    Then I should see the updated contact without the image
    When I delete the phase contact
    Then I should see the contact deletion complete successfully

  Scenario: Developer admin
    Given I am logged in as a Developer Admin
    And there is a phase
    When I create a developer contact
    Then I should see the created contact
    When I create a phase contact
    Then I should see the created contact
    And I update the contact
    Then I should see the updated contact
    When I remove an image from a contact
    Then I should see the updated contact without the image
    When I delete the phase contact
    Then I should see the contact deletion complete successfully

  Scenario: Division admin
    Given I am logged in as a Division Admin
    And there is a division phase
    Then I should not be able to create a developer contact
    When I create a division contact
    Then I should see the created contact
    When I create a division phase contact
    Then I should see the created contact
    And I update the contact
    Then I should see the updated contact
    When I remove an image from a contact
    Then I should see the updated contact without the image
    When I delete the division phase contact
    Then I should see the contact deletion complete successfully

  Scenario: Division Development admin
    Given I am logged in as a Development Admin for a Division
    And there is a division phase
    Then I should not be able to create a developer contact
    And I should not be able to create a division contact
    When I create a development contact
    Then I should see the created contact
    When I create a division phase contact
    Then I should see the created contact
    And I update the contact
    Then I should see the updated contact
    When I remove an image from a contact
    Then I should see the updated contact without the image
    When I delete the division phase contact
    Then I should see the contact deletion complete successfully
