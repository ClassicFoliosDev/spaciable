Feature: Homeowner Search
  As a homeowner
  I want to search Hoozzi content
  To find stuff about my home

  @javascript
  Scenario:
    Given I am logged in as a homeowner want to download my documents
    And there are contacts
    And there is a division
    And there is a division development
    And there are division contacts
    And there are faqs
    And there are notifications
    And there are how-tos
    When I search for a finish
    Then I see the matching finish
    When I search for a room
    Then I see the matching room
    When I search for a contact
    Then I see the matching contact
    When I search for a contact for another division
    Then I see no matches
    When I search for an FAQ
    Then I see the matching FAQ
    When I search for a notification
    Then I see the matching notification
    When I search for a how-to
    Then I see the matching how-to
    When I search for an appliance
    Then I see the matching appliance manual
    When I search for an appliance
    Then I see the matching appliance
    When I search for a document
    Then I see the matching document
    When I search for something that is not matched
    Then I see no matches
