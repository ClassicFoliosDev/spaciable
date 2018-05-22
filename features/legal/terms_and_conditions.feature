Feature: Terms and Conditions
  As a homeowner
  I want to be able to see terms and conditions and privacy policy
  To understand what I am committing to when I use Hoozzi

  Scenario: Upload privacy and cookies files
    Given I am logged in as a CF Admin
    And I have run the settings seeds
    When I visit the settings page
    And I upload a data privacy file
    Then I should see the data privacy file has been uploaded
    And I upload a cookies information file
    Then I should see the cookies information file has been uploaded
    When I log out as a an admin
    And I visit the privacy page directly
    Then I see the data privacy file
    And I visit the cookies page directly
    Then I see the cookies policy file

  Scenario: Developer Admin
    Given I am logged in as a Developer Admin
    And I have run the settings seeds
    Then I can not visit the settings page

  Scenario:  Homeowner
    Given I am logged in as a homeowner
    When I visit the ts_and_cs page
    Then I should see the terms and conditions for using Hoozzi

  Scenario: Admin
    Given I am logged in as a CF Admin
    When I visit the admin ts_and_cs page
    Then I should see the terms and conditions for administrators using Hoozzi

  Scenario: Logged out
    When I visit the ts_and_cs page directly
    Then I should see the terms and conditions for using Hoozzi
    When I visit the admin ts_and_cs page directly
    Then I should see the terms and conditions for administrators using Hoozzi

  @javascript
  Scenario: Accept and reset terms and conditions
    Given I am a Development Admin wanting to assign a new resident to a plot
    And a CF admin has configured a video link
    And I assign a new resident to a plot
    Then I should not be recorded as accepting ts and cs
    When I visit the invitation accept page
    And I accept the invitation as a homeowner
    Then I should be redirected to the video introduction page
    And I should have been recorded as accepting ts and cs
    When the ts and cs are reset
    Then I should not be recorded as accepting ts and cs
    And I should be prompted for ts and cs on next action
    When I accept the ts and cs
    Then I should have been recorded as accepting ts and cs
    When I log out as a homeowner
    Then I should not be prompted for ts and cs
    Given there is a second homeowner
    When I log in as the second homeowner
    Then I should be prompted for ts and cs
