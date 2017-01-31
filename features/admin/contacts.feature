Feature: Contacts
  As a CF Admin
  I want to create contacts
  So that homeowners know who to contact for help

  @javascript
  Scenario:
    Given I am logged in as an admin
    When I create a contact with no email or phone
    Then I should see the contact create fail
    When I create a contact
    Then I should see the created contact
    When I update the contact
    Then I should see the updated contact
    When I remove an image from a contact
    Then I should see the updated contact without the image

  @javascript
  Scenario: Delete
    Given I am logged in as an admin
    And I have created a contact
    When I delete the contact
    Then I should see the contact deletion complete successfully
