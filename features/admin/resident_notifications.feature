@javascript @slow
Feature: Resident Notifications
  As an Admin
  I want to be able to notify residents in bulk
  So that I am efficient in communicating updates to many residents

  Scenario: Send to all
    Given I am CF Admin wanting to send notifications to residents

    When I send a notification to all residents
    Then all residents should receive a notification
    And I can see the notification I sent to all residents

  Scenario: CF Admin
    Given I am CF Admin wanting to send notifications to residents

    When I send a notification to residents under a Developer
    Then all residents under that Developer should receive a notification
    And I can see the Developer notification I sent

    When I send a notification to residents under a Division
    Then all residents under that Division should receive a notification
    And I can see the Division notification I sent

    When I send a notification to residents under a Development
    Then all residents under that Development should receive a notification
    And I can see the Development notification I sent

    When I send a notification to residents under a Phase
    Then all residents under that Phase should receive a notification
    And I can see the Phase notification I sent

    When I send a notification to a resident under a (Phase) Plot
    Then the resident under that (Phase) Plot should receive a notification
    And I can see the (Phase) Plot notification I sent to the resident

  Scenario: Developer Admin
    Given I am Developer Admin wanting to send notifications to residents

    When I send a notification to residents under my Developer
    Then all residents under my Developer should receive a notification
    And I can see the Developer notification I sent

    When I send a notification to residents under a Division
    Then all residents under that Division should receive a notification
    And I can see the Division notification I sent

    When I send a notification to residents under a Development
    Then all residents under that Development should receive a notification
    And I can see the Development notification I sent

    When I send a notification to residents under a Phase
    Then all residents under that Phase should receive a notification
    And I can see the Phase notification I sent

    When I send a notification to a resident under a (Phase) Plot
    Then the resident under that (Phase) Plot should receive a notification
    And I can see the (Phase) Plot notification I sent to the resident

  Scenario: Division Admin
    Given I am Division Admin wanting to send notifications to residents

    When I send a notification to residents under my Division
    Then all residents under my Division should receive a notification
    And I can see the Division notification I sent

    When I send a notification to residents under a (Division) Development
    Then all residents under that (Division) Development should receive a notification
    And I can see the (Division) Development notification I sent

    When I send a notification to residents under a (Division) Phase
    Then all residents under that (Division) Phase should receive a notification
    And I can see the (Division) Phase notification I sent

  Scenario: Development Admin
    Given I am Development Admin wanting to send notifications to residents

    When I send a notification to residents under my Development
    Then all residents under my Development should receive a notification
    And I can see the Development notification I sent

    When I send a notification to residents under a Phase
    Then all residents under that Phase should receive a notification
    And I can see the Phase notification I sent

    When I send a notification to a resident under a (Phase) Plot
    Then the resident under that (Phase) Plot should receive a notification
    And I can see the (Phase) Plot notification I sent to the resident

  Scenario: (Division) Development Admin
    Given I am (Division) Development Admin wanting to send notifications to residents

    When I send a notification to residents under my (Division) Development
    Then all residents under my (Division) Development should receive a notification
    And I can see the (Division) Development notification I sent

    When I send a notification to residents under a (Division) Phase
    Then all residents under that (Division) Phase should receive a notification
    And I can see the (Division) Development notification I sent

  Scenario: Role
    Given I am Developer Admin wanting to send notifications to residents
    And there is a tenant

    When I send a notification to homeowner residents under my Developer
    Then all homeowner residents under my Developer should receive a notification
    And tenants should not receive a notification

    When I send a notification to tenant residents under my Developer
    Then all tenant residents under my Developer should receive a notification
    And homeowners should not receive a notification

    When I send a notification to homeowner and tenant residents under my Developer
    Then all residents under my Developer should receive a notification
