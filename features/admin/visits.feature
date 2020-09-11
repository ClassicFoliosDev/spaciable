@javascript @poke
Feature: Visits
  As a CF Admin
  I want to track homeowner visits
  So that we can analyse homeowner behaviour

  Scenario: No Visits
  Given I have seeded the timeline
  And I have a TimelineFixture.england timeline
  Given there are diverse developments with plots and residents
  And I have seeded the timeline
  And I have a TimelineFixture.england timeline
  When I log in as resident 1_1
  And I navigate through the homeowner site
  Then I log out as a homeowner
  When I log in as resident 1_2
  And I navigate through the homeowner site
  Then I log out as a homeowner
  And I log in as resident 2_1
  And I navigate through the homeowner site
  When I log out as a homeowner
  And I log in as CF admin
  Then I can access the page visits report
  And I can see the visits made
  And I can filter by developer developer1
  And I can filter by developer developer1 development development1_1
  And I can filter by business nhbc
  And I can filter by date
  And I can generate a report




