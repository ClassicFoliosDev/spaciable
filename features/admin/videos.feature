@javascript @slow
Feature: FAQs
  As an Admin
  I want to CRUD videos for developments
  So that homeowners can see relevant videos for their development

  Scenario: CF Admin
    Given I am logged in as a CF Admin
    When I create a video
    Then I should see the created video
    When I update the video
    Then I should see the updated video
    When I delete the video
    Then I should no longer see the video

  Scenario: Developer Admin
    Given I am logged in as a Developer Admin
    When I create a video
    Then I should see the created video

  Scenario: Division Admin
    Given I am logged in as a Division Admin
    When I create a video for the division development
    Then I should see the created video

  Scenario: Development Admin
    Given I am logged in as a Development Admin
    When I create a video
    Then I should see the created video

  Scenario: (Division) Development Admin
    Given I am logged in as a Development Admin for a Division
    When I create a video for the division development
    Then I should see the created video
    When I update the video
    Then I should see the updated video
    When I delete the video
    Then I should no longer see the video
