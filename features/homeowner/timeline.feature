@javascript @poke
Feature: Homeowner Timeline
  As a homeowner
  If a timeline is associated with my home
  I want to see my timeline

  Scenario: Homeowner with Timeline
    Given I have seeded the timeline
    And I have a TimelineFixture.england timeline
    Given I am logged in as a homeowner
    And my home is associated with the TimelineFixture.england timeline
    Then I can begin My Journey
    And I can answer yes to task First
    And I can answer no to task Second
    And I can answer no to tasks Third,Forth,Fifth,Sixth,Seventh,Eigth,Ninth,Tenth
    And I should see the incomplete timeline message
    And I can answer yes to tasks First,Second,Third,Forth,Fifth,Sixth,Seventh,Eigth,Ninth,Tenth
    And I should see the complete timeline message

  Scenario: Homeowner without Timeline
    Given I am logged in as a homeowner
    And my home is not associated with the TimelineFixture.england timeline
    Then I cannot begin My Journey
