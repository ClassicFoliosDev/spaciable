Feature: Notifications
  As a homeowner
  I want to review my notifications
  So that I find out information from my developer, division and development

  @javascript
  Scenario:
    Given I am logged in as a homeowner wanting to read notifications
    And there is a second notification plot
    When I read the notifications
    Then I should see the notifications list
    And All my notifications should be unread
    And I should not see notifications for other residents in my development
    When I click on a notification summary
    Then I should see the expanded notification
    And the notification status in my header should be updated
    When I show the plots
    And I switch to the second plot
    When I read the notifications
    Then I should see the notifications list
    And the notification status in my header should be updated

  @javascript
  Scenario: Plot progress notifications
    Given I am logged in as a homeowner wanting to read notifications
    And I log out as a homeowner
    And I am logged in as an admin
    And I update the notification plot progress
    And I log out as a an admin
    When I log in as a notification homeowner
    Then I should see a notification for the updated plot progress
