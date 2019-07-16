@javascript @poke
Feature: Admin Notifications
  As a CF Admin
  I want to be able to notify admins in bulk
  So that I am efficient in communicating updates to many admins

  Scenario: Send to all
    Given I am a CF Admin wanting to send a notification to Admins
    When I send a notification to all admins
    Then I can see the notification I sent to all admins
    And an email is sent to all admins

  Scenario: Send to developer
    Given I am a CF Admin wanting to send a notification to Admins
    When I send a notification to a particular developer
    Then I can see the notification I sent to the developer
    And an email is sent to the developer admins
