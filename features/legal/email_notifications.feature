@javascript
Feature: Legal emails
  As a homeowner
  I do not want to receive emails unless I have actively subscribed
  To protect my inbox from junk

  Scenario: Non-activated homeowner
    Given I am a homeowner
    And I have not yet activated my account
    Given I am CF Admin wanting to send notifications to residents
    When I update the plot progress
    And I send a notification to the development
    Then no emails are sent to the unactivated homeowner

  Scenario: Homeowner declined email notifications
    Given I am a Development Admin wanting to assign a new resident to a plot
    And a CF admin has configured a video link
    When I assign a new resident to a plot
    And I log out as a an admin
    When I visit the invitation accept page
    And I do not accept terms and conditions
    Then I can not complete registration
    When I accept the invitation as a homeowner
    Then I should be redirected to the video introduction page
    And I should be redirected to the homeowner dashboard
    And I should not receive email notifications
    When I log out as a homeowner
    And I log in as a Development Admin
    When I update the resident plot progress
    And I send a notification to the resident's development
    Then no emails are sent to the activated homeowner

  Scenario: Homeowner accepted services and email notifications
    Given I am a Development Admin wanting to assign a new resident to a plot
    And the developer has enabled services
    And a CF admin has configured a video link
    And I have seeded the database with services
    When I assign a new resident to a plot
    And I log out as a an admin
    When I visit the invitation accept page
    And I choose email notifications
    And I accept the invitation as a homeowner
    Then I should be redirected to the video introduction page
    When I select my services
    Then My services have been selected
    And I should receive email notifications
