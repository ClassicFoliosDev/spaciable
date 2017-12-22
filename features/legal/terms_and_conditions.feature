Feature: Terms and Conditions
  As a homeowner
  I want to be able to see terms and conditions and privacy policy
  To understand what I am committing to when I use Hoozzi

  Scenario:  Homeowner
    Given I am logged in as a homeowner
    When I visit the ts_and_cs page
    Then I should see the terms and conditions for using Hoozzi
    When I visit the privacy page
    Then I should see the privacy information for using Hoozzi

  Scenario: Admin
    Given I am logged in as a CF Admin
    When I visit the ts_and_cs page
    Then I should see the terms and conditions for administrators using Hoozzi
    When I visit the privacy page
    Then I should see the privacy information for using Hoozzi

  Scenario: Logged out
    When I visit the ts_and_cs page directly
    Then I should see the terms and conditions for using Hoozzi
    When I visit the admin ts_and_cs page directly
    Then I should see the terms and conditions for administrators using Hoozzi
    When I visit the privacy page directly
    Then I should see the privacy information for using Hoozzi
