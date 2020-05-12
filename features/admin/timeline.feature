@poke
Feature: Timeline
  As a CF Admin
  I want to create and edit timelines
  So that I can attach them to plots

  @javascript
  Scenario: Create a Timeline
    Given I am logged in as an admin
    Given I have seeded the timeline
    Then I can create a TimelineFixture.england timeline
    And I can see the TimelineFixture.england timeline created successfully
    And I can edit the TimelineFixture.england timeline to TimelineFixture.scotland
    When I show the TimelineFixture.scotland timeline
    Then the TimelineFixture.scotland timeline has no tasks
    Then I t("tasks.show.add_task") the Third task into TimelineFixture.scotland
    Then I should see task Third added successfully
    And I should see the Third task in position 1 of the TimelineFixture.scotland timeline
    Then I add task First t("tasks.show.insert_before", page: "Third") for TimelineFixture.scotland
    Then I should see task First added successfully
    And I should see the First task in position 1 of the TimelineFixture.scotland timeline
    And I should see the Third task in position 2 of the TimelineFixture.scotland timeline
    Then I add task Second t("tasks.show.insert_after", page: "First") for TimelineFixture.scotland
    Then I should see task Second added successfully
    And I should see the First task in position 1 of the TimelineFixture.scotland timeline
    And I should see the Second task in position 2 of the TimelineFixture.scotland timeline
    And I should see the content of task Second
    And I should see the Third task in position 3 of the TimelineFixture.scotland timeline
    Then I add tasks Forth,Fifth,Sixth,Seventh,Eigth,Ninth,Tenth after task Third for TimelineFixture.scotland timeline
    Then tasks First to Tenth should appear in order for TimelineFixture.scotland
    When I update task Fifth with Fifty for TimelineFixture.scotland
    Then I should see task Fifty updated successfully
    Then I should see the content of task Fifty
    When I update task Fifty with Fifth for TimelineFixture.scotland
    Then I should see task Fifth updated successfully
    Then I should see the content of task Fifth
    And I add tasks Fifty after task Fifth for TimelineFixture.scotland timeline
    When I delete task Fifty
    Then I should see task Fifty deleted successfully
    And tasks First to Tenth should link together positive
    And tasks First to Tenth should link together negative
    When I t("tasks.show.add_finale") finale content
    Then I can see the complete content finale in the timeline
    And I can see the incomplete content finale in the timeline

  @javascript
  Scenario: CF Admin Clone a Timeline
    Given I am logged in as an admin
    And I have seeded the timeline
    And I have a TimelineFixture.england timeline
    When I clone the TimelineFixture.england timeline
    Then I should see a TimelineFixture.england_copy timeline
    When I select the TimelineFixture.england_copy timeline
    Then tasks First to Tenth should appear in order for TimelineFixture.england_copy

  @javascript
  Scenario: CF Admin Clone Timeline for Developer
    Given I am logged in as an admin
    And I have seeded the timeline
    And I have a TimelineFixture.england timeline
    And there is a developer
    And I enable My Journey for a developer
    Then I can view developer timelines
    And I can import the global TimelineFixture.england timeline
    When I log out as an admin
    And I am logged in as a Developer Admin
    Then I can see the developers timelines
    And I should see a TimelineFixture.england_copy timeline
    When I select the TimelineFixture.england_copy timeline
    Then tasks First to Tenth should appear in order for TimelineFixture.england_copy
