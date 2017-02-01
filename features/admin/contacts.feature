@slow
Feature: Contacts
  As a CF Admin
  I want to create contacts
  So that homeowners know who to contact for help

  @javascript
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

  @javascript
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

  @javascript
  Scenario: Development
    Given I am logged in as an admin
    And there is a developer with a development
    When I create a development contact with no name or organisation
    Then I should see the contact create fail
    When I create a contact
    Then I should see the created contact
    When I update the contact
    Then I should see the updated contact
    When I remove an image from a contact
    Then I should see the updated contact without the image
    When I delete the development contact
    Then I should see the contact deletion complete successfully
