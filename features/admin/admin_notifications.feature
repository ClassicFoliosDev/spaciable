@javascript @poke
Feature: Admin Notifications
  As a CF Admin
  I want to be able to notify admins in bulk
  So that I am efficient in communicating updates to many admins

  Scenario: Send to all
    Given I am CF Admin wanting to send notifications to Admins

    When I send a notification to all admins
    Then I can see the notification I sent to all admins