@javascript @poke
Feature: Calendar
  As an admin I want to be able to create and manage calendar events
  As a homeowner I want to be able to respond to calendar invitations

  @javascript
  Scenario Outline: Create, Update and Delete Development Calendar event
    Given I am logged in as an admin
    And there is a phase plot with residents
    And the calendar is initialised
    When I go to the <type> I see a calendar tab
    When I click on the <type> calendar tab I see a calendar
    And I can add a <type> event using the Add Event button
    And I can update a <type> event
    And I can delete an event
    And I can create a <type> event by clicking on the calendar
    Examples:
      | type        |
      | development |
      | phase       |
      | plot        |

  @javascript
  Scenario: Create, Update and Delete repeating events
    Given I am logged in as an admin
    And there is a phase plot with residents
    And the calendar is initialised
    And I go to the plot calendar
    Then I can add a repeating calendar event
    And I can update and delete a single calendar event
    And I can update and delete this and following calendar events
    And I can update and delete all events

  @javascript
  Scenario: Update repeating event periods
    Given I am logged in as an admin
    And there is a phase plot with residents
    And the calendar is initialised
    And I go to the plot calendar
    Then I can add a daily repeating calendar event
    Then I can update to weekly repeating
    Then I can update to biweekly repeating
    Then I can update to monthly repeating
    Then I can update to yearly repeating

  @javascript
  Scenario: Admin/Homeowner event negotiation
    Given I am logged in as an admin
    And there is a phase plot with residents
    And the calendar is initialised
    And I go to the plot calendar
    And I can add a plot event and invite the resident
    When I log out as a an admin
    And I log in as the plot resident
    Then I can see an invite on my plot calendar
    And I can accept the plot event
    When I log out as a homeowner
    And I log in as an admin
    And I go to the plot calendar
    Then I can see the event has been accepted
    When I log out as a an admin
    And I log in as the plot resident
    Then I can see an accept on my plot calendar
    And I can decline the plot event
    When I log out as a homeowner
    And I log in as an admin
    And I go to the plot calendar
    Then I can see the event has been declined
    When I log out as a an admin
    And I log in as the plot resident
    Then I can see an decline on my plot calendar
    And I can propose an amendment to the date and time
    When I log out as a homeowner
    And I am logged in as a Site Admin
    And I go to the plot calendar
    Then I can see the event has been rescheduled
    And I can view but not update the rescheduled event
    When I log out as a an admin
    And I log in as an admin
    And I go to the plot calendar
    Then I can see the event has been rescheduled
    And I can accept the rescheduled date and time
    When I log out as a an admin
    And I log in as the plot resident
    Then I can see an invite on my plot calendar

  @javascript
  Scenario Outline: Admin/Homeowner development/phase event acceptance/decline
    Given I am logged in as an admin
    And there is a phase plot with residents
    And the calendar is initialised
    And I go to the <type> calendar
    And I can add a <type> event and invite the resident
    When I log out as a an admin
    And I log in as the plot resident
    Then I can see an invite on my <type> calendar
    And I cannot renegotiate the event time
    And I can accept the <type> event
    When I log out as a homeowner
    And I log in as an admin
    And I go to the <type> calendar
    Then I can see the <type> event has been accepted
    When I log out as a an admin
    And I log in as the plot resident
    Then I can see an accept on my <type> calendar
    And I can decline the <type> event
    When I log out as a homeowner
    And I log in as an admin
    And I go to the <type> calendar
    Then I can see the <type> event has been declined
    Examples:
      | type        |
      | development |
      | phase       |

  @javascript
  Scenario: Development with no calendar
    Given I am logged in as an admin
    And there is a phase plot with residents
    And the development has calendar disabled
    When I go to the calendar plot I dont see a calendar tab
    When I log out as a an admin
    And I log in as the plot resident
    Then I cannot see a calendar
