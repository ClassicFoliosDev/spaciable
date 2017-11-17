Feature: Notifications
  As a homeowner
  I want to review my notifications
  So that I find out information from my developer, division and development

  @javascript
  Scenario:
    Given I am logged in as a homeowner wanting to read notifications
    When I read the notifications
    Then I should see the notifications list
    And I should not see notifications for other residents in my development
    When I click on a notification summary
    Then I should see the expanded notification
    And the notification status in my header should change
